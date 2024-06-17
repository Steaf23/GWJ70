extends State


func entry() -> void:
	$Timer.start()


func exit() -> void:
	$Timer.stop()



func _on_timer_timeout() -> void:
	change_state.emit("IdleState")
