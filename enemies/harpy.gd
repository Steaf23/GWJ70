extends Actor

@export var target: Node2D


func _ready() -> void:
	$AIController.navigation_target = target
