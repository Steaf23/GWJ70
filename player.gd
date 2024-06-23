class_name Player
extends Actor

signal player_died()

@onready var anim = $Pivot/Sprite2D/AnimationPlayer
@onready var slashanim = $WeaponPivot/HitSprite/AnimationPlayer
@onready var hitanim = $WeaponPivot/dmg/AnimationPlayer

@onready var weapon_pivot = $WeaponPivot
@onready var hit_sprite = $WeaponPivot/HitSprite

@onready var special_attack_bar = $CanvasLayer/MarginContainer/HBoxContainer/SpecialAttackBar
@onready var special_attack_key = $CanvasLayer/MarginContainer/HBoxContainer/InputKey

var count = 0
var attacking = false
var rightside = false

var combo_count = 0


func _ready() -> void:
	%Sword.hide()
	%Sword.disable(true)
	$StaffRange.disable(true)
	hit_sprite.hide()
	
	special_attack_bar.max_value = $SpecialAttackCooldown.wait_time
	special_attack_bar.step = 0.1
	special_attack_key.set_key(&"special_attack")
	

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if can_turn:
		if velocity.x < -10.0:
			weapon_pivot.scale = Vector2(-1, 1)
			rightside = true
		elif velocity.x > 10.0:
			weapon_pivot.scale = Vector2(1, 1)
			rightside = false
		
	if attacking:
		count += 1
		if count == 4:
			%Sword.hide()
			%Sword.disable(true)
			$StateMachine.invoke("end_attack")
			count = 0
			attacking = false
	
	$StateDebug.text = $StateMachine.current_state.name
	special_attack_key.set_key(&"special_attack")
	special_attack_key.visible = $SpecialAttackCooldown.is_stopped()
	special_attack_bar.value = $SpecialAttackCooldown.wait_time - $SpecialAttackCooldown.time_left

func _input(event: InputEvent) -> void:
	if %Sword.is_disabled() and event.is_action_pressed("normal_attack") and $AttackCooldown.is_stopped():
		%Sword.show()
		%Sword.disable(false)
		attacking = true
		
		$StateMachine.invoke("attack", [combo_count])
		combo_count = (combo_count + 1) % 3
		$AttackCooldown.start()
	
	if %Sword.is_disabled() and event.is_action_pressed("special_attack") and $SpecialAttackCooldown.is_stopped():
		$StateMachine.invoke("special_attack")


func play_animation(animation: StringName) -> void:
	assert(animation in anim.get_animation_list())
	anim.play(animation)
	if "attack" in animation:
		hit_sprite.show()
		slashanim.play("slash")
		await slashanim.animation_finished
		hit_sprite.hide()


func cast_spell() -> void:
	start_spell()
	await get_tree().create_timer(0.15).timeout
	end_spell()


func start_spell() -> void:
	$StaffRange.disable(false)

func end_spell() -> void:
	$StaffRange.disable(true)


func _on_health_bar_no_health() -> void:
	player_died.emit()


func _on_damaged(damage: int, damage_source: Actor, pierce: bool) -> void:
	if $IFrames.is_stopped():
		$HealthBar.current_health -= damage
		SoundManager.play_random_sfx(Sounds.HIT)
		$IFrames.start()

func heal() -> void:
	$HealthBar.current_health = $HealthBar.max_health
