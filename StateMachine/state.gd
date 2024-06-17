class_name State
extends Node

@onready var machine: StateMachine = get_parent()
var signals = []

var next_states: Array[String] = []

signal change_state(to_state: String)

func _entry() -> void:
	for s in signals:
		s.signal.connect(s.callable, s.flags)
	entry()

func _exit() -> void:
	exit()
	signals = get_incoming_connections()
	for s in signals:
		s.signal.disconnect(s.callable)


func entry() -> void:
	pass

func do(delta: float) -> void:
	pass
	
func exit() -> void:
	pass
