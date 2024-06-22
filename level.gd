class_name Level
extends Node2D

const RESOLUTION: Vector2 = Vector2(480, 270)

@onready var exit_arrow = $CanvasLayer/ExitArrow

signal level_completed()

@onready var sections = $Sections
@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var exit = $SectionExit

var current_section = 0


func _ready() -> void:
	exit.get_node("Collision").disabled = true
			
	for s in $Sections.get_children():
		s.body_exited.connect(_on_body_section_exited)
		s.section_cleared.connect(_on_section_cleared)
	
	$Sections.get_node("Section" + str(current_section + 1)).active = true


func set_left_wall_section(section: int) -> void:
	left_wall.global_position.x = section * RESOLUTION.x
	left_wall.set_meta("section", section)
	$Player/Camera2D.limit_left = current_section * RESOLUTION.x


func set_right_wall_section(section: int) -> void:
	right_wall.global_position.x = section * RESOLUTION.x
	right_wall.set_meta("section", section)
	$Player/Camera2D.limit_right = current_section * RESOLUTION.x + (RESOLUTION.x - 1)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("normal_attack"):
		set_right_wall_section(right_wall.get_meta("section") + 1)
		set_left_wall_section(left_wall.get_meta("section") + 1)
	if event.is_action_pressed("special_attack"):
		set_right_wall_section(right_wall.get_meta("section") - 1)
		set_left_wall_section(left_wall.get_meta("section") - 1)


func _on_section_exit_player_entered() -> void:
	current_section += 1
	set_right_wall_section(current_section)
	exit.get_node("Collision").disabled = true
	exit.global_position.x += RESOLUTION.x
	if current_section > 0:
		$Sections.get_node("Section" + str(current_section + 1)).active = false
	if current_section < $Sections.get_child_count():
		$Sections.get_node("Section" + str(current_section + 1)).active = true


func _on_body_section_exited(body: Node2D) -> void:
	if not body is Player:
		return
	set_left_wall_section(current_section)
	
	
func _on_section_cleared(section: int) -> void:
	assert(section == current_section, " Cleared wrong section; " + str(section) + " instead of " + str(current_section))
	exit_arrow.show()
	exit.get_node("Collision").disabled = false
