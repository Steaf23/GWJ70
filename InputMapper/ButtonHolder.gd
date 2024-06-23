extends VBoxContainer

@onready var REBIND_BUTTON: PackedScene = preload("res://InputMapper/key_bind_button.tscn")


func add_button(action: KeyActions.RebindableAction):
	var button = REBIND_BUTTON.instantiate()
	add_child(button)
	button.use_button(true)
	button.set_meta("action", action)
	update_button(button, action.keycode)
	
	return button


func update_button(button: KeybindButton, keycode: Key):
	var updated_meta: KeyActions.RebindableAction = button.get_meta("action")
	button.action_name = updated_meta.action_id
	button.update_key()
	updated_meta.keycode = keycode
	button.set_meta("action", updated_meta)
