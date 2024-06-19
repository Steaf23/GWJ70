extends Control

signal finished()

var text: DialogText
var current = 0

@onready var speaker_lbl = %Speaker
@onready var text_lbl = %Text


func _ready() -> void:
	for b in 3:
		var button = get_button(b)
		button.text = "..."
		button.pressed.connect((func(b): _on_choice_button_pressed(b.get_meta("choice_id"))).bind(button))
		button.set_meta("choice_id", -1)
	
	load_text_from_file("res://resources/dialog0.tres")


func load_text_from_file(dialog_path: String) -> void:
	load_text(load(dialog_path))


func load_text(_text: DialogText) -> void:
	text = _text
	current = 0
	update_gui()
	text.print_text()
	

func update_gui() -> void:
	if text.choices[current].size() == 0:
		finished.emit()
		return
	
	text_lbl.text = "..."
	clear_buttons()
	if text.choices[current].size() > 1:
		var button_idx = 0
		for choice_id in text.choices[current]:
			var button = get_button(button_idx)
			button.text = text.get_line(choice_id)
			button.set_meta("choice_id", choice_id)
			button.disabled = false
			button_idx += 1
	else:
		%Next.disabled = false
		text_lbl.text = text.get_line(text.choices[current][0])
		
		
func clear_buttons() -> void:
	for b in 3:
		var button = get_button(b)
		button.text = "..."
		button.set_meta("choice_id", -1)
		button.disabled = true
	
	%Next.disabled = true


func _on_restart_pressed() -> void:
	current = 0
	update_gui()


func _on_choice_button_pressed(choice_id: int) -> void:
	if choice_id == -1:
		if text.choices[current].size() == 0:
			finished.emit()
			return
		current = text.choices[current][0]
	else:
		current = choice_id
	update_gui()


func get_button(number: int) -> Button:
	return get_node("VBoxContainer/Control/Button" + str(number)) as Button


func _on_next_pressed() -> void:
	_on_choice_button_pressed(-1)
