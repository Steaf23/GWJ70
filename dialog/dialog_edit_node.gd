class_name DialogEditNode
extends GraphNode

@onready var event_line = preload("res://dialog/event_line.tscn")


func _on_delete_pressed() -> void:
	delete_request.emit()
	
	
func get_text() -> String:
	return %Text.text


func set_text(text: String) -> void:
	%Text.text = text


func disable_remove() -> void:
	$Control4/Delete.hide()


func get_events() -> Array:
	var events = []
	for c in %Events.get_children():
		events.append(c.event)
	return events

func _on_add_event_pressed() -> void:
	var event = event_line.instantiate()
	event.event = %EventName.text
	%Events.add_child(event)


func set_events(events: Array) -> void:
	for c in %Events.get_children():
		c.queue_free()
		
	for e in events:
		var event = event_line.instantiate()
		event.event = e
		%Events.add_child(event)
