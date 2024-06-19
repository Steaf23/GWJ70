class_name Player
extends Actor

@onready var anim = $Sprite2D/AnimationPlayer
@onready var slashanim = $Sprite2D/AnimationPlayer

var count = 0
var attacking = true
var rightside = true

var combo_count = 0


func _ready() -> void:
	%Sword.hide()
	%Sword.disable(true)
	$Pivot/HitSprite.hide()
	

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if velocity.x < -10.0:
		$Pivot.scale = Vector2(-1, 1)
		rightside = true
	elif velocity.x > 10.0:
		$Pivot.scale = Vector2(1, 1)
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


func _input(event: InputEvent) -> void:
	if %Sword.is_disabled() and event.is_action_pressed("normal_attack"):
		%Sword.show()
		%Sword.disable(false)
		attacking = true
		
		$StateMachine.invoke("attack", [combo_count])
		combo_count = (combo_count + 1) % 3
	
	if %Sword.is_disabled() and event.is_action_pressed("special_attack"):
		$StateMachine.invoke("special_attack")


func play_animation(animation: StringName) -> void:
	assert(animation in $Sprite2D/AnimationPlayer.get_animation_list())
	$Sprite2D/AnimationPlayer.play(animation)
	if "attack" in animation:
		$Pivot/HitSprite.show()
		$Pivot/HitSprite/AnimationPlayer.play("slash")
		await $Pivot/HitSprite/AnimationPlayer.animation_finished
		$Pivot/HitSprite.hide()
