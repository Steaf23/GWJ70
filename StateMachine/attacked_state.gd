extends State

@export var shape: CollisionShape2D

func entry() -> void:
	shape.self_modulate = Color.RED


func exit() -> void:
	shape.self_modulate = Color.WHITE
