extends PanelContainer

@onready var selectPopup = $KeySelectPopup
@onready var buttonHolder = %ButtonHolder
@onready var inputMapper = $InputMapper

@onready var audio_tick = &"res://Util/SoundManager/tick.wav"

func _ready():
	for action in KeyActions.actions:
		var button = buttonHolder.add_button(action)
		button.pressed.connect(_on_rebind_button_pressed.bind(button))
		button.reset_pressed.connect(_on_reset_button_pressed.bind(button))
		if !InputMap.has_action(action.action_id):
			InputMap.add_action(action.action_id)


func _on_rebind_button_pressed(button):
	SoundManager.play_sfx(audio_tick)
	set_process_input(false)
	
	selectPopup.open()
	var keycode = await selectPopup.key_selected
	inputMapper.change_action_key(button.get_meta("action"), keycode)
	buttonHolder.update_button(button, keycode)
	
	set_process_input(true)


func _on_reset_button_pressed(button): 
	SoundManager.play_sfx("res://Assets/Audio/tick.wav")
	var keycode = KeyActions.get_default_key(button.get_meta("action").action_id)
	inputMapper.change_action_key(button.get_meta("action"), keycode)
	buttonHolder.update_button(button, keycode)
