extends State


func entry() -> void:
	machine.actor.play_animation("being_hit")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	change_state("BlockingState")