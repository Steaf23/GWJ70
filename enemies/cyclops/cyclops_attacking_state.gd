extends "res://state_machine/states/attacking_state.gd"


func entry() -> void:
	super.entry()
	machine.actor.can_turn = false
	

func exit() -> void:
	super.exit()
	machine.actor.can_turn = true


func _on_cyclops_damaged(damage: int, damage_source: Actor, pierce: bool) -> void:
	if machine.actor.hitbox.is_disabled():
		machine.actor.do_damage(damage)


func do(delta: float) -> void:
	if machine.actor.dead:
		change_state("DeathState")
