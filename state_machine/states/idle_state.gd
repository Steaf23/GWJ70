extends State

var count = 0

func entry() -> void:
	count = 0
	machine.actor.can_walk = true
	

func _on_enemy_damaged(damage: int, damage_source: Actor, type: HitBox.DamageType) -> void:
	if type == HitBox.DamageType.SPELL:
		machine.actor.damage(damage)
		machine.actor.apply_knockback(damage_source.global_position, 500)
		change_state("StunnedState")
		return
			
	if count >= 30:
		change_state("BlockingState")
	else:
		machine.actor.damage(damage)
		change_state("StunnedState")
	

func do(delta: float) -> void:
	count += 1
	
	machine.actor.play_moving_animation()
	
	if machine.actor.dead:
		change_state("DeathState")
	
	if machine.actor.leap_precondition() and $"../../LeapCooldown".is_stopped():
		$"../../LeapCooldown".start()
		change_state("LeapingState")


func exit() -> void:
	machine.actor.can_walk = false
