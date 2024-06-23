class_name Level
extends Node2D

const RESOLUTION: Vector2 = Vector2(480, 270)

@onready var exit_arrow = $CanvasLayer/ExitArrow

signal level_completed()

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var exit = $SectionExit

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
		
	

func set_left_wall_section(section: int) -> void:
	left_wall.global_position.x = section * RESOLUTION.x
	left_wall.set_meta("section", section)
	$Player/Camera2D.limit_left = Global.current_section * RESOLUTION.x


func set_right_wall_section(section: int) -> void:
	right_wall.global_position.x = section * RESOLUTION.x
	right_wall.set_meta("section", section)
	$Player/Camera2D.limit_right = Global.current_section * RESOLUTION.x + (RESOLUTION.x - 1)


func _on_section_exit_player_entered() -> void:
	Global.current_section += 1
	set_right_wall_section(Global.current_section)
	exit.get_node("Collision").disabled = true
	exit.global_position.x += RESOLUTION.x
	if Global.current_section > 0:
		$Sections.get_node("Section" + str(Global.current_section + 1)).active = false
	if Global.current_section < $Sections.get_child_count():
		$Sections.get_node("Section" + str(Global.current_section + 1)).active = true


func _on_body_section_exited(body: Node2D) -> void:
	if not body is Player:
		return
	set_left_wall_section(Global.current_section)


func _on_section_cleared(section: int) -> void:
	assert(section == Global.current_section, " Cleared wrong section; " + str(section) + " instead of " + str(Global.current_section))
	exit_arrow.show()
	exit.get_node("Collision").set_deferred("disabled", false)
