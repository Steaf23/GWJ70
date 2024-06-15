class_name PlayerController
extends ActorController


func _physics_process(delta: float) -> void:
	desired_velocity = actor.move_speed * Input.get_vector("left", "right", "up", "down")
