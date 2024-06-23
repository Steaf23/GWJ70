extends State

var speed = 0

func entry() -> void:
	speed = machine.actor.move_speed
	machine.actor.play_animation("cast_spell")
	machine.actor.move_speed *= 0.45
	$"../../SpecialAttackCooldown".start()
	SoundManager.play_random_sfx(Sounds.SPELL)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	change_state("IdleState")


func exit() -> void:
	machine.actor.move_speed = speed
