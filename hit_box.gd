class_name HitBox
extends Area2D

@export var damage = 1
@export var kill_on_hit = false

@export var damage_source: Actor

signal hit_damagable(body, damage, damage_source: Actor)
signal hit(body, damage_source: Actor)

var disabled = false


func _on_body_entered(body: Node2D) -> void:
	if body == get_parent():
		return
		
	if body.is_in_group("damageable"):
		if kill_on_hit:
			body.kill(damage_source)
		else:
			#SoundManager.play_random_sfx([Sounds.HIT_0, Sounds.HIT_1])
			body.take_damage(damage, damage_source)
		hit_damagable.emit(body, damage, damage_source)
	else:
		hit.emit(body, damage_source)
		
		
func disable(value: bool) -> void:
	disabled = value
	for s in get_children():
		if "disabled" in s:
			s.disabled = value


func is_disabled() -> bool:
	return disabled
