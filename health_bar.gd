extends Control

signal no_health()
signal health_changed(old_health, new_health)
signal max_health_changed(old_health, new_health)

@export var max_health: float = 10:
	set(value):
		var old = max_health
		max_health = value
		
		if old != max_health:
			max_health_changed.emit(old, max_health)
			
		if not is_node_ready():
			await ready
		
		progress.max_value = max_health
		current_health = clamp(current_health, 0, max_health)


@onready var current_health: float = max_health:
	set(value):
		var old = current_health
		current_health = value
		if current_health <= 0.00001:
			current_health = 0
			no_health.emit()
		
		if old != current_health:
			health_changed.emit(old, current_health)
		
		if not is_node_ready():
			await ready
		
		progress.value = current_health
		
		
@onready var progress = $Progress

func _ready() -> void:
	current_health = max_health
