class_name StateMachine
extends Node

@export var actor: Actor
@export var current_state: State

@onready var states = {}


func _ready() -> void:
	for c in get_children():
		if c is State:
			states[c.name] = c
			c.request_state_change.connect(_on_state_change.bind(c))
			c._exit()
			remove_child(c)
			
	add_child(current_state)
	current_state._entry()
	
	
func _physics_process(delta: float) -> void:
	current_state.do(delta)
	
	
func _on_state_change(to_state: String, from_state: State) -> void:
	assert(from_state == current_state, "Cannot change state from outside the current state!")
	assert(to_state in states.keys(), "Cannot find state named '" + to_state + "'!")

	current_state._exit()
	remove_child(current_state)
	current_state = states[to_state]
	add_child(current_state)
	current_state._entry()	


func invoke(method: StringName, args: Array = []) -> void:
	if current_state.has_method(method):
		current_state.callv(method, args)
