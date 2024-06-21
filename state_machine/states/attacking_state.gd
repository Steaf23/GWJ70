extends State

func entry() -> void:
	machine.actor.play_animation("attack1")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "attack1":
		change_state("IdleState")


func exit() -> void:
	machine.actor.finish_attack()
