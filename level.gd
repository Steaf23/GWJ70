class_name Level
extends Node2D

@onready var exit_arrow = $CanvasLayer/ExitArrow

signal level_completed()


func _ready() -> void:
	for c in $Enemies.get_children():
		if c is Actor:
			c.died.connect(_on_actor_died)


func _on_actor_died() -> void:
	if $Enemies.get_children().filter(
		func(a): 
			return a is Actor and not a.dead
			).is_empty():
		print("You won the level!")
		exit_arrow.show()
