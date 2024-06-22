extends State

var count = 0

func entry() -> void:
	count = 0
	machine.actor.can_walk = true
	

func _on_enemy_damaged(damage: int, damage_source: Actor, type: HitBox.DamageType) -> void:
	if type == HitBox.DamageType.SPELL:
		machine.actor.do_damage(damage)
		machine.actor.apply_knockback(damage_source.global_position, 500)
		change_state("StunnedState")
		return
			
	if count >= 30:
		change_state("BlockingState")
	else:
		machine.actor.do_damage(damage)
		change_state("StunnedState")
	

func do(delta: float) -> void:
	count += 1
	
	machine.actor.play_moving_animation()
	
	if machine.actor.dead:
		change_state("DeathState")
	
	if machine.actor.can_attack():
		change_state("AttackingState")
		return

func exit() -> void:
	machine.actor.can_walk = false
