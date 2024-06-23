extends MarginContainer


func set_key(action_name: StringName) -> void:
	%Key.text = KeyActions.get_key_string_from_code(KeyActions.get_action(action_name).keycode)


func set_manually(text: String) -> void:
	%Key.text = text
