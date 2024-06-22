class_name HurtBox
extends Area2D

signal taken_damage(amount: int, damage_source: Actor, pierce: bool)


func take_damage(amount: int, damage_source: Actor, pierce: bool) -> void:
	taken_damage.emit(amount, damage_source, pierce)
