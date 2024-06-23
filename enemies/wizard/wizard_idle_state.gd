extends "res://state_machine/states/idle_state.gd"


func entry() -> void:
	$IdleTimeout.start()


func exit() -> void:
	$IdleTimeout.stop()


func _on_idle_timeout_timeout() -> void:
	machine.actor.controller.navigation_target = machine.actor
