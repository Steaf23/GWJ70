extends Control

signal finished()

@onready var backup = preload("res://resources/backup_dialog.tres")

var text: DialogText
var current = 0

@onready var text_lbl = %Text

var events_seen = []


func _ready() -> void:
	for b in 3:
		var button = get_button(b)
		button.text = "..."
		button.pressed.connect((func(_button): _on_choice_button_pressed(_button.get_meta("choice_id"))).bind(button))
		button.set_meta("choice_id", -1)


func load_text_from_file(dialog_path: String) -> void:
	load_text(load(dialog_path))


func load_text(_text: DialogText) -> void:
	events_seen = []
	text = _text
	if not text:
		text = backup
	current = 0
	update_gui()
	Global.dialog_shown = true
	get_tree().paused = true
	show()
	

func update_gui() -> void:
	if current >= text.lines.size():
		Global.dialog_shown = false
		get_tree().paused = false
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
			button.show()
			button_idx += 1
		%Next.disabled = true
	else:
		%Next.disabled = false
	events_seen.append_array(text.events[current])
	text_lbl.text = text.get_line(current)
		
		
func clear_buttons() -> void:
	for b in 3:
		var button = get_button(b)
		button.text = "..."
		button.set_meta("choice_id", -1)
		button.disabled = true
		button.hide()
	
	%Next.disabled = true


func _on_restart_pressed() -> void:
	current = 0
	update_gui()


func _on_choice_button_pressed(choice_id: int) -> void:
	if choice_id == -1:
		if text.choices[current].size() == 0:
			Global.dialog_shown = false
			get_tree().paused = false
			finished.emit()
			hide()
			return
		current = text.choices[current][0]
	else:
		current = text.choices[choice_id][0]
		events_seen.append_array(text.events[choice_id])
	update_gui()


func get_button(number: int) -> Button:
	return get_node("VBoxContainer/Control/Button" + str(number)) as Button


func _on_next_pressed() -> void:
	_on_choice_button_pressed(-1)


func get_events() -> Array:
	return events_seen
