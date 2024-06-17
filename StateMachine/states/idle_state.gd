extends State

var count = 0

func entry() -> void:
	count = 0
	

func _on_enemy_damaged(damage: int, damage_source: Actor) -> void:
	if count >= 10:
		change_state.emit("BlockingState")
	else:
		machine.actor.damage(damage)
		change_state.emit("BlockingState")
		

func do(delta: float) -> void:
	count += 1
