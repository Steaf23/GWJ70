extends HBoxContainer


var event: String = "":
	set(value):
		event = value
		$Label.text = event


func _on_button_pressed() -> void:
	queue_free()
