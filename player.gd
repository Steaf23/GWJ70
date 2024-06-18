extends Actor

func _ready() -> void:
	%Sword.hide()
	%Sword.disable(true)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
	if velocity.x < -10.0:
		$Pivot.scale = Vector2(-1, 1)
		$Sprite2D.scale = Vector2(-1, 1)
	elif velocity.x > 10.0:
		$Pivot.scale = Vector2(1, 1)
		$Sprite2D.scale = Vector2(1, 1)


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
