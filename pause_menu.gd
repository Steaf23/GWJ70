extends VBoxContainer

var unpaused_mouse_mode

var paused = false

func _ready() -> void:
	hide()
	

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") or (event.is_pressed() and event is InputEventKey and event.physical_keycode == KEY_ESCAPE):
		toggle_pause()


func toggle_pause() -> void:
	if paused:
		unpause()
	else:
		pause()
		

func pause() -> void:
	show()
	paused = true
	unpaused_mouse_mode = Input.mouse_mode
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	SoundManager.muffle_music(true)
	get_tree().paused = true
	
	
func unpause() -> void:
	hide()
	paused = false
	Input.mouse_mode = unpaused_mouse_mode
	SoundManager.muffle_music(false)
	if not Global.dialog_shown:
		get_tree().paused = false


func _on_resume_pressed() -> void:
	toggle_pause()
	$ButtonClick.play()


func _on_tab_container_tab_clicked(_tab: int) -> void:
	$ButtonClick.play()
