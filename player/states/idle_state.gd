extends State


func do(delta: float) -> void:
	if not machine.actor.rightside:
		machine.actor.play_animation("idle_left")
	else:
		machine.actor.play_animation("idle_right")


func attack(combo: int) -> void:
	change_state("AttackState")
