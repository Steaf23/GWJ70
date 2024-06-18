extends State

var count = 0

func entry() -> void:
	count = 0
	

func _on_enemy_damaged(damage: int, damage_source: Actor) -> void:
	if count >= 30:
		change_state("BlockingState")
	else:
		machine.actor.damage(damage)
		change_state("BlockingState")
		

func do(delta: float) -> void:
	count += 1
