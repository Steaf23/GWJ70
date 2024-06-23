class_name Section
extends Area2D

signal section_cleared(section: int)

@export var section: int = 0
@export var color: Color = Color.WHITE 

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


func add_actor(actor: Actor) -> void:
	actor.died.connect(_on_actor_died)
	$Enemies.add_child(actor)
	actor.global_position = Global.clamp_pos_to_section(actor.global_position)


func spawn_actors(actors: Array[Actor]) -> void:
	print("Spawning_monsters in " + str(Global.current_section))
	var markers = []
	
	for c in get_children():
		if c is Marker2D:
			markers.append(c)
	var markers_shuffled = markers.duplicate()
	markers_shuffled.shuffle()
	for actor in actors:
		actor.died.connect(_on_actor_died)
		$Enemies.add_child(actor)
		if markers_shuffled.size() == 0:
			markers_shuffled = markers.duplicate()
			markers_shuffled.shuffle()
		actor.global_position = markers_shuffled.pop_back().global_position
