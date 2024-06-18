extends State

func entry() -> void:
	$Timer.start()
	$"../../CollisionShape2D".self_modulate = Color.YELLOW
	

func exit() -> void:
	$Timer.stop()
	$"../../CollisionShape2D".self_modulate = Color.WHITE


func _on_timer_timeout() -> void:
	change_state.emit("IdleState")


func _on_enemy_damaged(damage: int, source: Actor) -> void:
	$"../../AnimationPlayer".play("block")
	machine.actor.apply_knockback(source.global_position, 250)
	change_state.emit("BlockingState")