class_name Level
extends Node2D

const RESOLUTION: Vector2 = Vector2(480, 270)

@onready var exit_arrow = $CanvasLayer/ExitArrow

signal level_completed()

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var exit = $SectionExit
@onready var camera = $Player/Camera2D

var sections: Array[Section] = []


func _ready() -> void:
	Global.level = self
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
	queue_redraw()
	camera.move_left_limit(Global.current_section * RESOLUTION.x, time)


func set_right_wall_section(section: int, time: float = 0.01) -> void:
	right_wall.global_position.x = section * RESOLUTION.x
	right_wall.set_meta("section", section)
	queue_redraw()
	camera.move_right_limit(Global.current_section * RESOLUTION.x + (RESOLUTION.x - 1), time)


func _on_section_exit_player_entered() -> void:
	Global.current_section += 1
	set_right_wall_section(Global.current_section, 3)
	exit.get_node("Collision").set_deferred("disabled", true)
	exit.global_position.x += RESOLUTION.x
	if Global.current_section > 0:
		$Sections.get_node("Section" + str(Global.current_section + 1)).active = false
	if Global.current_section < $Sections.get_child_count():
		$Sections.get_node("Section" + str(Global.current_section + 1)).active = true
	
	exit_arrow.hide()
	

func _on_body_section_exited(body: Node2D) -> void:
	if not body is Player:
		return
	set_left_wall_section(Global.current_section, 3)


func _on_section_cleared(section: int) -> void:
	assert(section == Global.current_section, " Cleared wrong section; " + str(section) + " instead of " + str(Global.current_section))
	exit_arrow.show()
	exit.get_node("Collision").set_deferred("disabled", false)


func _draw() -> void:
	draw_circle(Vector2(Global.current_section * RESOLUTION.x + (RESOLUTION.x - 1), $Player.global_position.y), 10, Color.BLUE)
	draw_circle(Vector2(Global.current_section * RESOLUTION.x, $Player.global_position.y), 10, Color.RED)
