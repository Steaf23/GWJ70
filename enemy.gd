extends Actor

@onready var block_timer: Timer = $BlockTimer

signal damaged(damage: int, damage_source: Actor)

func take_damage(damage: int, damage_source: Actor) -> void:
	damaged.emit(damage, damage_source)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	$StateStatus.text = $AttackMachine.current_state.name


func _on_block_timer_timeout() -> void:
	$CollisionShape2D.modulate = Color.WHITE


func damage(num) -> void:
	$HealthBar.current_health -= num
