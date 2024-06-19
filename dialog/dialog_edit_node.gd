class_name DialogEditNode
extends GraphNode


func _on_delete_pressed() -> void:
	delete_request.emit()
	
	
func get_text() -> String:
	return %Text.text


func set_text(text: String) -> void:
	%Text.text = text


func disable_remove() -> void:
	$Control4/Delete.hide()
