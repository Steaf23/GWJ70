extends "res://state_machine/states/idle_state.gd"


func do(delta: float) -> void:
	super.do(delta)
	
	if machine.actor.can_leap():
		change_state("LeapingState")
		return
