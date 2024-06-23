extends Node

signal keybinds_updated()

var default_actions: Array[RebindableAction] = [
	RebindableAction.new(&"left", KEY_A, &"Move Left"),
	RebindableAction.new(&"right", KEY_D, &"Move Right"),
	RebindableAction.new(&"up", KEY_W, &"Move Up"),
	RebindableAction.new(&"down", KEY_S, &"Move Down"),
	RebindableAction.new(&"normal_attack", KEY_SPACE, &"Sword Attack"),
	RebindableAction.new(&"special_attack", KEY_SHIFT, &"Staff Attack"),
	RebindableAction.new(&"pause", KEY_P, &"Pause Game"),
	]
	
var actions: Array[RebindableAction] = [
	RebindableAction.new(&"left", KEY_A, &"Move Left"),
	RebindableAction.new(&"right", KEY_D, &"Move Right"),
	RebindableAction.new(&"up", KEY_W, &"Move Up"),
	RebindableAction.new(&"down", KEY_S, &"Move Down"),
	RebindableAction.new(&"normal_attack", KEY_SPACE, &"Sword Attack"),
	RebindableAction.new(&"special_attack", KEY_SHIFT, &"Staff Attack"),
	RebindableAction.new(&"pause", KEY_P, &"Pause Game"),
	]


func get_action(action_name: StringName) -> RebindableAction:
	for action in actions:
		if action.action_id == action_name:
			return action
	return null


func get_default_key(action_name: StringName) -> Key:
	for action in default_actions:
		if action.action_id == action_name:
			return action.keycode
	return KEY_W
			

func update_action_key(action_name: StringName, keycode: Key) -> void:
	for action in actions:
		if action.action_id == action_name:
			action.keycode = keycode
			keybinds_updated.emit()


func get_key_string_from_code(code: Key) -> String:
	var key_string = PackedByteArray([code]).get_string_from_utf8()
	match code:
		KEY_SPACE: key_string = "SPACE"
		KEY_LEFT: key_string = "LEFT"
		KEY_RIGHT: key_string = "RIGHT"
		KEY_DOWN: key_string = "DOWN"
		KEY_UP: key_string = "UP"
		KEY_ENTER: key_string = "ENTER"
		KEY_SHIFT: key_string = "SHIFT"
		KEY_ESCAPE: key_string = "ESC"
		
	if key_string == " ":
		key_string = "SPACE"
	
	return key_string
	

class RebindableAction:
	var action_id: StringName
	var keycode: Key
	var display_name: StringName
	
	
	func _init(_action_id: String, _keycode: Key, _display_name: String) -> void:
		self.action_id = _action_id
		self.keycode = _keycode
		self.display_name = _display_name
