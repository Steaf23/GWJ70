class_name AIController
extends ActorController

@export var navigation_target: Node2D
@export var target_pos_delta = 25 * 25

@onready var target_position: Vector2 = global_position
@onready var navigation = $NavigationAgent2D

func _ready() -> void:
	set_physics_process(false)
	await get_tree().physics_frame
	await get_tree().physics_frame
	set_physics_process(true)


func _physics_process(delta: float) -> void:
	if not navigation_target:
		return
		
	var update_target_position = target_position.distance_squared_to(navigation_target.global_position) > target_pos_delta
	
	if navigation.is_navigation_finished():
		update_target_position = true
		
	if update_target_position:
		target_position = navigation_target.global_position
		navigation.target_position = target_position
	
	var next_pos = navigation.get_next_path_position()
	
	var direction = global_position.direction_to(next_pos)
	var new_velocity = direction * actor.move_speed
	navigation.velocity = new_velocity

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	desired_velocity = safe_velocity
