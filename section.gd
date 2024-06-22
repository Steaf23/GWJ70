extends Area2D

signal section_cleared(section: int)

@export var section: int = 0

@onready var active = false


func _ready() -> void:
	for c in $Enemies.get_children():
		if c is Actor:
			c.died.connect(_on_actor_died)

	await get_tree().physics_frame
	_on_actor_died()

func _on_actor_died() -> void:
	if not active:
		return
		
	if $Enemies.get_children().filter(
		func(a): 
			return a is Actor and not a.dead
			).is_empty():
		print("Cleared section " + str(section))
		section_cleared.emit(section)
