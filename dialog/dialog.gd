extends Control

var text: DialogText
var current = 0

@onready var speaker_lbl = %Speaker
@onready var text_lbl = %Text


func _ready() -> void:
	load_text_from_file("res://resources/test_text.tres")


func load_text_from_file(dialog_path: String) -> void:
	load_text(load(dialog_path))


func load_text(_text: DialogText) -> void:
	text = _text
	current = 0
	update_gui()
	

func update_gui() -> void:
	if text.choices[current].size() == 0:
		print("FINITO")
	
	return
		


func _on_restart_pressed() -> void:
	current = 0
	update_gui()
