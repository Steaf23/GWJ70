extends State


func entry() -> void:
	machine.actor.play_animation("die")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "die":
		machine.actor.queue_free()
