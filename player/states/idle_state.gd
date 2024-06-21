extends State


func do(delta: float) -> void:
	var walking = machine.actor.controller.desired_velocity.length() > 20
	if not machine.actor.rightside:
		if walking:
			machine.actor.play_animation("walk_left")
		else:
			machine.actor.play_animation("idle_left")
	else:
		if walking:
			machine.actor.play_animation("walk_right")
		else:
			machine.actor.play_animation("idle_right")


func attack(combo: int) -> void:
	change_state("AttackState")


func special_attack() -> void:
	change_state("SpecialAttackState")
