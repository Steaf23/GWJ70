class_name Level
extends Node2D

const RESOLUTION: Vector2 = Vector2(480, 270)

@onready var exit_arrow = $CanvasLayer/ExitArrow

signal level_completed()

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var exit = $SectionExit
@onready var camera = $Player/Camera2D
@onready var dialog = $DialogLayer/Dialog
@onready var player = $Player

var sections: Array[Section] = []
var first_time = true

var next_events = []

func _ready() -> void:
	randomize()
	Global.level = self
	Global.current_section = 0
	Global.dialog_shown = false
	
	start_dialog("res://resources/prologue.tres")
	
	exit.get_node("Collision").disabled = true
			
	for s in $Sections.get_children():
		s.body_exited.connect(_on_body_section_exited)
		s.section_cleared.connect(_on_section_cleared)
		sections.append(s)
	
	$Sections.get_node("Section" + str(Global.current_section + 1)).active = true
	
	set_left_wall_section(Global.current_section)
	set_right_wall_section(Global.current_section)
		
	

func set_left_wall_section(section: int, time: float = 0.01) -> void:
	left_wall.global_position.x = section * RESOLUTION.x
	left_wall.set_meta("section", section)
	camera.move_left_limit(Global.current_section * RESOLUTION.x, time)


func set_right_wall_section(section: int, time: float = 0.01) -> void:
	if (section == 4):
		section = 5
	right_wall.global_position.x = section * RESOLUTION.x
	right_wall.set_meta("section", section)
	camera.move_right_limit(Global.current_section * RESOLUTION.x + (RESOLUTION.x - 1), time)


func _on_section_exit_player_entered() -> void:
	start_dialog("res://resources/dialog" + str(Global.current_section) + ".tres")
	

func _on_body_section_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	activate_monsters()
	set_left_wall_section(Global.current_section, 3)
	


func _on_section_cleared(section: int) -> void:
	assert(section == Global.current_section, " Cleared wrong section; " + str(section) + " instead of " + str(Global.current_section))
	exit_arrow.show()
	exit.get_node("Collision").set_deferred("disabled", false)


func start_dialog(filepath: String) -> void:
	dialog.load_text_from_file(filepath)
	SoundManager.play_music(Sounds.MUSIC_DIALOG)
	

func _on_dialog_finished() -> void:
	var events = dialog.get_events()
	next_events = events
	start_next_section()
	
	
func start_next_section() -> void:
	exit_arrow.hide()
	player.heal()
	exit.get_node("Collision").set_deferred("disabled", true)
	
	if not first_time:
		first_time = false
		Global.current_section += 1
		if (Global.current_section >= 6):
			game_won()
			return
		
		set_right_wall_section(Global.current_section, 3)
		exit.global_position.x += RESOLUTION.x
		if Global.current_section > 0:
			$Sections.get_node("Section" + str(Global.current_section + 1)).active = false
		if Global.current_section < $Sections.get_child_count():
			$Sections.get_node("Section" + str(Global.current_section + 1)).active = true
		spawn_monsters(next_events)	
	else:
		first_time = false
		spawn_monsters(next_events)
		activate_monsters()
	
	SoundManager.play_music(Sounds.MUSIC_BATTLE)


func spawn_monsters(events: Array) -> void:
	var actors: Array[Actor] = []
	for e in events:
		var split = e.split("_")
		var mob_name = split[0]
		var count = 1
		if split.size() == 2:
			count = int(split[1])
			
		var actor_scene: PackedScene
		match mob_name:
			"goblin": actor_scene = preload("res://enemies/goblin/goblin.tscn")
			"ghost": actor_scene =preload("res://enemies/ghost/ghost.tscn")
			"cyclops": actor_scene =preload("res://enemies/cyclops/cyclops.tscn")
			"wizard": actor_scene =preload("res://enemies/wizard/wizard.tscn")
		for i in count:
			var actor = actor_scene.instantiate() as Enemy
			actors.append(actor)
		
	sections[Global.current_section].spawn_actors(actors)


func activate_monsters() -> void:
	for a in sections[Global.current_section].get_actors():
		a.target = player


func _on_player_died() -> void:
	section_lost()
	

func game_won() -> void:
	$WinScreen.show()
	get_tree().paused = true
	Global.dialog_shown = true
	SoundManager.play_music(Sounds.MUSIC_WIN)


func section_lost() -> void:
	get_tree().paused = true
	Global.dialog_shown = true
	$GameOver.show()


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu.tscn")
