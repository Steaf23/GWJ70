extends AIController

@export var wander_range = 100

var move_target: Vector2
var has_target = false


func _ready() -> void:
	super._ready()
	pick_target()
	

func _physics_process(delta: float) -> void:
	if not navigation_target:
		return
		
	if not has_target:
		has_target = true
		target_position = pick_target()
		move_target = target_position
		navigation.target_position = target_position
	
	var next_pos = navigation.get_next_path_position()
	
	var direction = global_position.direction_to(next_pos)
	var new_velocity = direction * actor.move_speed
	navigation.velocity = new_velocity


func pick_target() -> Vector2:
	var target = global_position + Vector2.RIGHT.rotated(randf_range(0, TAU)) * wander_range
	target = Global.clamp_pos_to_section(target)
	return target


func _on_navigation_agent_2d_navigation_finished() -> void:
	$IdleTimeout.start()


func _on_idle_timeout_timeout() -> void:
	move_target = pick_target()
	has_target = false
