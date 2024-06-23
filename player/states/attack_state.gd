extends State


func entry() -> void:
	machine.actor.can_turn = false
	machine.actor.play_animation("idle_left")
	var combo = machine.actor.combo_count + 1
	if not machine.actor.rightside:
		machine.actor.play_animation("attack" + str(combo) + "_left")
	else:
		machine.actor.play_animation("attack" + str(combo) + "_right")
	SoundManager.play_random_sfx(Sounds.SWORD_SWING)

func attack(combo: int) -> void:
	change_state("AttackState")


func end_attack() -> void:
	pass


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if "attack" in anim_name:
		change_state("IdleState")


func exit() -> void:
	machine.actor.can_turn = true
