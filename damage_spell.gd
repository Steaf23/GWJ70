extends Actor


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	_on_health_bar_no_health()
