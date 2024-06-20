extends State

var preparing = true
var target: Vector2 = Vector2()
var leaping = false

func entry() -> void:
	machine.actor.can_walk = false
	preparing = true
	machine.actor.play_animation("being_hit")
	$PrepareTimer.start()
	target = machine.actor.controller.navigation_target.global_position
	
	
func do(delta: float) -> void:
	if $PrepareTimer.is_stopped() and not leaping:
		leaping = true
		preparing = false
		machine.actor.leap_to_position(target)
		machine.actor.play_animation("attack2")

	
func exit() -> void:
	preparing = true
	machine.actor.can_walk = true
	leaping = false


func _on_enemy_leaped() -> void:
	change_state("IdleState")
