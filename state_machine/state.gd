class_name State
extends Node

@onready var machine: StateMachine = get_parent()
var signals = []

var next_states: Array[String] = []

signal request_state_change(to_state: String)

func _entry() -> void:
	for s in signals:
		s.signal.connect(s.callable, s.flags)
	entry()


func _exit() -> void:
	signals = get_incoming_connections()
	for s in signals:
		s.signal.disconnect(s.callable)
	exit()


func entry() -> void:
	pass

func do(delta: float) -> void:
	pass
	
func exit() -> void:
	pass


func change_state(new_state: StringName) -> void:
	request_state_change.emit(new_state)	
