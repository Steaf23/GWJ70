class_name HitBox
extends Area2D

enum DamageType {NORMAL, SPELL}

@export var damage = 1
@export var kill_on_hit = false
@export var type: DamageType = DamageType.NORMAL

@export var damage_source: Actor

signal hit_damagable(body, damage, damage_source: Actor, type: DamageType)
signal hit(body, damage_source: Actor, type: DamageType)

var disabled = false


func _on_body_entered(body: Node2D) -> void:
	if body == get_parent() or body == damage_source:
		return
		
	if body.is_in_group("damageable"):
		if kill_on_hit:
			body.kill(damage_source)
		else:
			#SoundManager.play_random_sfx([Sounds.HIT_0, Sounds.HIT_1])
			body.take_damage(damage, damage_source, type)
		hit_damagable.emit(body, damage, damage_source, type)
	else:
		hit.emit(body, damage_source, type)
		
		
func disable(value: bool) -> void:
	disabled = value
	for s in get_children():
		if "disabled" in s:
			s.disabled = value


func is_disabled() -> bool:
	return disabled
