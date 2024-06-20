class_name Actor
extends CharacterBody2D

@export var controller: ActorController
@export var move_speed: int = 100

var dead = false

signal attacked()
signal died()

var knockback_velocity: Vector2 = Vector2()

var can_walk = true
var can_turn = true

func _physics_process(delta: float) -> void:
	if !controller: return
	
	var walk_velocity = controller.desired_velocity if can_walk else Vector2()
	velocity = walk_velocity + knockback_velocity
	move_and_slide()
	
	knockback_velocity = lerp(knockback_velocity, Vector2(), 0.2)


func _on_health_bar_no_health() -> void:
	dead = true
	died.emit()
	queue_free()


func take_damage(amount: int, damage_source: Actor, pierce: bool) -> void:
	attacked.emit()
	%HealthBar.current_health -= amount


func apply_knockback(from_pos: Vector2, force: float) -> void:
	knockback_velocity += from_pos.direction_to(global_position) * force
