class_name Actor
extends CharacterBody2D

@export var controller: ActorController
@export var move_speed: int = 100


func _physics_process(delta: float) -> void:
	if !controller: return
	
	velocity = controller.desired_velocity
	move_and_slide()
