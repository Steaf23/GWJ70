extends State

func entry() -> void:
	machine.actor.can_walk = true
	$Timer.start()
	machine.actor.start_block()
	

func exit() -> void:
	machine.actor.can_walk = false
	$Timer.stop()
	machine.actor.finish_block()


func _on_timer_timeout() -> void:
	change_state("IdleState")


func _on_enemy_damaged(damage: int, source: Actor, pierce: bool) -> void:
	if pierce:
		machine.actor.apply_knockback(source.global_position, 500)
		machine.actor.do_damage(damage)
		return
		
	machine.actor.apply_knockback(source.global_position, 250)
	change_state("BlockingState")
	if source is Player:
		source.combo_count = 0
