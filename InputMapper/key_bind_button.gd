class_name KeybindButton
extends MarginContainer

signal pressed()
signal reset_pressed()

@export var action_name: StringName
@export var use_as_button: bool = false:
	set(value):
		use_as_button = value
		
		if not is_node_ready():
			await ready
			
		$Button.disabled = !value


func _ready() -> void:
	use_button(use_as_button)
	$Button.pressed.connect( func(): pressed.emit())


func update_key() -> void:
	var action: KeyActions.RebindableAction = KeyActions.get_action(action_name)
	if action == null:
		return
		
	%Key.text = KeyActions.get_key_string_from_code(action.keycode)
	%Label.text = action.display_name


func set_label_visible(_visible: bool) -> void:
	%Label.visible = _visible


func use_button(value: bool) -> void:
	$Button.disabled = !value
	use_as_button = value


func _on_reset_pressed() -> void:
	reset_pressed.emit()
