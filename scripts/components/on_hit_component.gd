extends Node
class_name OnHitComponent

@export var damage: float
@export var status_effects: Array[Data.StatusEffectType]

func setup(damage_: float, status_effects_: Array[Data.StatusEffectType]) -> void:
	damage = damage_
	status_effects = status_effects_
