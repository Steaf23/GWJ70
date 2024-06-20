extends Actor

@export var target: Node2D
@onready var block_timer: Timer = $BlockTimer
@onready var anim = $Sprite2D/AnimationPlayer
@export var leap_range = 100
@export var leap_curve = Curve2D.new()

signal damaged(damage: int, damage_source: Actor, pierce: bool)
signal leaped()

func _ready() -> void:
	$AIController.navigation_target = target

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
	print("LEAPING RN")
	print(pos)
	
	var start_pos = global_position
	var final_target_pos = start_pos.direction_to(pos)
	print(final_target_pos)
	final_target_pos *= leap_range
	final_target_pos += start_pos
	
	var upper_pos = lerp(start_pos, final_target_pos, 0.5)
	upper_pos.y += 20
	
	global_position = final_target_pos
	#leaped.emit()
	#return

	
	var curve = Curve2D.new()
	curve.add_point(start_pos)
	#curve.add_point(upper_pos)
	curve.add_point(final_target_pos)
	print(curve.get_baked_length(), " ", start_pos.distance_to(final_target_pos))
	print(start_pos, upper_pos, final_target_pos)
	
	var move_to_point_on_curve = func(val): 
		print(val)
		global_position = start_pos.slerp(final_target_pos, val)
	var tween = create_tween()
	tween.tween_method(move_to_point_on_curve, 0.0, 1.0, 0.7)
	
	await tween.finished
	leaped.emit()
