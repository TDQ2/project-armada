extends Resource
class_name OnHitData

@export var damage: float
@export var status_effects: Array[Data.StatusEffectType]

func _init(damage_: float = 0, status_effects_: Array[Data.StatusEffectType] = []) -> void:
	damage = damage_
	status_effects = status_effects_
