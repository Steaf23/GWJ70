extends Enemy

@export var summon_enemy: PackedScene
@export var max_move_distance = 200

var summon_position


func finish_attack() -> void:
	super.finish_attack()
	
	var enemy = summon_enemy.instantiate() as Enemy
	enemy.global_position = summon_position
	enemy.target = target
	Global.add_actor_to_game(enemy)


func can_attack() -> bool:
	return $AttackCooldown.is_stopped() and global_position.distance_to(target.global_position) > attack_range

func start_attack_frames() -> void:
	summon_position = global_position + Vector2.RIGHT.rotated(randf_range(0, TAU)) * 50
	summon_position = Global.clamp_pos_to_section(summon_position)
	Global.show_summon_circle(summon_position)
