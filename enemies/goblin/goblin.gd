extends Enemy

@export var leap_range: int = 100

signal leaped()


func _ready() -> void:
	super._ready()
	$LeapLanding.disable(true)
	

func can_leap() -> bool:
	var attack_allowed = $AttackCooldown.is_stopped()
	var target = ($AIController as AIController).navigation_target
	var distance_to_target = global_position.distance_to(target.global_position)
	return distance_to_target < leap_range and distance_to_target > 75 and attack_allowed


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
