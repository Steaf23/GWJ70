extends Node

@onready var summon_circle = preload("res://summon_circle.tscn")

var current_section: int = 0

var level: Level

var dialog_shown = false


func add_actor_to_game(actor: Actor) -> void:
	if not level: return
	
	level.sections[current_section].add_actor(actor)


func show_summon_circle(position: Vector2) -> void:
	if not level: return
	
	var circle = summon_circle.instantiate()
	circle.global_position = position
	level.add_child(circle)


func clamp_pos_to_section(pos: Vector2) -> Vector2:
	if not level: 
		return pos
	
	var shape = level.sections[current_section].get_node("Shape")
	var shape_size = shape.shape.size / 2
	var shape_tl = shape.global_position - shape_size + Vector2(20, 20)
	var shape_br = shape.global_position + shape_size - Vector2(20, 20)
	return pos.clamp(shape_tl, shape_br)
