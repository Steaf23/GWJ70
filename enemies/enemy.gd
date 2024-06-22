class_name Enemy
extends Actor

enum EnemyAnimation {IDLE, WALK, DEATH, HIT, ATTACK, BLOCK, ATTACK2}

signal animation_finished(animation: EnemyAnimation) 

@export var target: Node2D
@export var attack_length_seconds: float = 0.3
@export var attack_range: int = 50
@export var has_block: bool = true

@onready var hitbox = $Pivot/AttackHitbox
@onready var anim = $Pivot/Sprite2D/AnimationPlayer
@onready var pivot = $Pivot


func _ready() -> void:
	$AIController.navigation_target = target
	hitbox.disable(true)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	$StateDebug.text = $StateMachine.current_state.name
	

func can_attack() -> bool:
	return $AttackCooldown.is_stopped() and global_position.distance_to(target.global_position) < attack_range


func can_block() -> bool:
	return has_block


func start_attack_frames() -> void:
	var target = ($AIController as AIController).navigation_target
	if target.global_position.x < global_position.x:
		pivot.scale = Vector2(1, 1)
	else:
		pivot.scale = Vector2(-1, 1)
		
	hitbox.disable(false)
	await get_tree().create_timer(attack_length_seconds).timeout
	hitbox.disable(true)


func finish_attack() -> void:
	$AttackCooldown.start()
	
	
func do_damage(num) -> void:
	$HealthBar.current_health -= num	


func play_animation(animation: EnemyAnimation) -> void:
	var anim_name: StringName
	match animation:
		EnemyAnimation.IDLE: anim_name = &"idle"
		EnemyAnimation.WALK: anim_name = &"walk"
		EnemyAnimation.DEATH: anim_name = &"death"
		EnemyAnimation.HIT: anim_name = &"hit"
		EnemyAnimation.BLOCK: anim_name = &"block"
		EnemyAnimation.ATTACK: anim_name = &"attack"
		EnemyAnimation.ATTACK2: anim_name = &"attack2"
	
	if not anim_name in anim.get_animation_list():
		animation_finished.emit(animation)
		print("Animation " + anim_name + " does not exist for " + name)
		return
		
	anim.play(anim_name)
	
	
func play_moving_animation() -> void:
	var vel = controller.desired_velocity
	var animation = EnemyAnimation.WALK

	if vel.length() < 10:
		animation = EnemyAnimation.IDLE
	
	play_animation(animation) 
	
	if vel.x < -5:
		pivot.scale = Vector2(1, 1)
	elif vel.x > 5:
		pivot.scale = Vector2(-1, 1)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	var animation: EnemyAnimation
	match anim_name:
		&"idle": animation = EnemyAnimation.IDLE
		&"walk": animation = EnemyAnimation.WALK
		&"death": animation = EnemyAnimation.DEATH
		&"hit": animation = EnemyAnimation.HIT
		&"attack": animation = EnemyAnimation.ATTACK
		&"block": animation = EnemyAnimation.BLOCK
		&"attack2": animation = EnemyAnimation.ATTACK2
	animation_finished.emit(animation)


func _on_health_bar_no_health() -> void:
	dead = true
