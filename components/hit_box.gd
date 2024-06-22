class_name HitBox
extends Area2D

enum DamageType {NORMAL, SPELL}

@export var damage = 1
@export var kill_on_hit = false
@export var type: DamageType = DamageType.NORMAL

@export var damage_source: Actor

var disabled = false


func _on_area_entered(area: Area2D) -> void:
	if area == get_parent() or area == damage_source or area.owner == owner:
		return
		
	if area.is_in_group("damageable"):
		if kill_on_hit:
			area.kill(damage_source)
		else:
			#SoundManager.play_random_sfx([Sounds.HIT_0, Sounds.HIT_1])
			area.take_damage(damage, damage_source, type)

		
func disable(value: bool) -> void:
	disabled = value
	for s in get_children():
		if "disabled" in s:
			s.disabled = value


func is_disabled() -> bool:
	return disabled
