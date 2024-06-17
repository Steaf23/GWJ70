class_name Level
extends Node2D


func _ready() -> void:
	$Enemies/Enemy/AIController.navigation_target = $Player

func _on_actor_died() -> void:
	if $Enemies.get_children().filter(func(a): a is Actor and not a.dead).is_empty():
		print("You won the level!")
		get_tree().reload_current_scene()
