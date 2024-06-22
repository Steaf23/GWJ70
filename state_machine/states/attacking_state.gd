extends State

func entry() -> void:
	machine.actor.play_animation(Enemy.EnemyAnimation.ATTACK)


func exit() -> void:
	machine.actor.finish_attack()


func _on_enemy_animation_finished(animation: Enemy.EnemyAnimation) -> void:
	if animation == Enemy.EnemyAnimation.ATTACK:
		change_state("IdleState")
