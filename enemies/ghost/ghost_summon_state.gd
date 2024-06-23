extends State


func entry() -> void:
	$"../../Pivot/Sprite2D/AnimationPlayer".play("summon")
	machine.actor.can_walk = false


func exit() -> void:
	machine.actor.can_walk = true


func _on_ghost_animation_finished(animation: Enemy.EnemyAnimation) -> void:
	change_state("IdleState")
