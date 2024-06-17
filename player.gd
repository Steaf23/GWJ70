extends Actor


func _ready() -> void:
	%Sword.hide()
	%Sword.disable(true)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	$Pivot.look_at(get_global_mouse_position())


func _input(event: InputEvent) -> void:
	if %Sword.is_disabled() and event.is_action_pressed("normal_attack"):
		await get_tree().physics_frame
		%Sword.show()
		%Sword.disable(false)
		await get_tree().physics_frame
		%Sword.hide()
		%Sword.disable(true)


func _on_attack_timer_timeout() -> void:
	pass
