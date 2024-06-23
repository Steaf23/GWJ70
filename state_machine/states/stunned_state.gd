extends State


func entry() -> void:
	machine.actor.play_animation(Enemy.EnemyAnimation.HIT)
	$StunTime.start()


func do(delta: float) -> void:
	if machine.actor.dead:
		change_state("DeathState")


func _on_enemy_animation_finished(animation: Enemy.EnemyAnimation) -> void:
	if machine.actor.has_block:
		change_state("BlockingState")
	else:
		change_state("IdleState")


func _on_stun_time_timeout() -> void:
	change_state("IdleState")
