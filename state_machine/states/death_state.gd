extends State


func entry() -> void:
	machine.actor.play_animation(Enemy.EnemyAnimation.DEATH)


func _on_enemy_animation_finished(animation: Enemy.EnemyAnimation) -> void:
	if animation == Enemy.EnemyAnimation.DEATH:
		machine.actor.died.emit()
		machine.actor.queue_free()
