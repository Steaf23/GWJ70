extends Actor

@export var target: Node2D
@onready var block_timer: Timer = $BlockTimer
@onready var anim = $Sprite2D/AnimationPlayer
@export var leap_range = 100
@export var leap_curve = Curve2D.new()
@export var attack_frame_time = 0.2

signal damaged(damage: int, damage_source: Actor, pierce: bool)
signal leaped()

func _ready() -> void:
	$AIController.navigation_target = target
	$LeapLanding.disable(true)
	$Pivot/AttackBox.disable(true)

func take_damage(_damage: int, damage_source: Actor, pierce: bool) -> void:
	damaged.emit(_damage, damage_source, pierce)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	$StateStatus.text = $AttackMachine.current_state.name


func _on_block_timer_timeout() -> void:
	$CollisionShape2D.modulate = Color.WHITE


func damage(num) -> void:
	$HealthBar.current_health -= num


func play_animation(animation: StringName) -> void:
	assert(animation in %AnimationPlayer.get_animation_list())
	
	if %AnimationPlayer.current_animation != animation:
		%AnimationPlayer.stop()
	%AnimationPlayer.play(animation)


func play_moving_animation() -> void:
	var vel = controller.desired_velocity
	var animation: StringName = &"walk"

	if vel.length() < 10:
		animation = &"idle"
	
	play_animation(animation) 
	
	if vel.x < -5:
		$Sprite2D.scale = Vector2(-1, 1)
	elif vel.x > 5:
		$Sprite2D.scale = Vector2(1, 1)


func _on_health_bar_no_health() -> void:
	dead = true
	

func leap_precondition() -> bool:
	return true
	

func leap_to_position(pos: Vector2) -> void:
	var start_pos = global_position
	var final_target_pos = start_pos.direction_to(pos)
	final_target_pos *= leap_range
	final_target_pos += start_pos
	
	var upper_pos = lerp(start_pos, final_target_pos, 0.5)
	upper_pos.y -= 20

	var curve = Curve2D.new()
	curve.add_point(Vector2(), Vector2())
	curve.add_point(upper_pos - start_pos)
	curve.add_point(final_target_pos - start_pos)
	
	var move_to_point_on_curve = func(val): 
		global_position = start_pos + curve.sample_baked(val, false)
	var tween = create_tween()
	tween.tween_method(move_to_point_on_curve, 0.0, curve.get_baked_length(), 0.7)
	
	await get_tree().create_timer(0.5).timeout
	$LeapLanding.disable(false)
	
	await tween.finished
	leaped.emit()
	$LeapLanding.disable(true)
	
	
func can_attack() -> bool:
	var target = ($AIController as AIController).navigation_target
	var distance_to_target = global_position.distance_to(target.global_position)
	return distance_to_target < 40 and $AttackCooldown.is_stopped()


func can_leap() -> bool:
	var attack_allowed = $AttackCooldown.is_stopped()
	var target = ($AIController as AIController).navigation_target
	var distance_to_target = global_position.distance_to(target.global_position)
	return distance_to_target < leap_range and distance_to_target > 75 and attack_allowed


func attack() -> void:
	var target = ($AIController as AIController).navigation_target
	if target.global_position.x < global_position.x:
		$Pivot.scale = Vector2(-1, 1)
	else:
		$Pivot.scale = Vector2(1, 1)
		
	$Pivot/AttackBox.disable(false)
	await get_tree().create_timer(attack_frame_time).timeout
	$Pivot/AttackBox.disable(true)


func finish_attack() -> void:
	$AttackCooldown.start()
	$Pivot/AttackBox.disable(true)
