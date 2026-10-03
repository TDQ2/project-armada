extends Resource
class_name OnHitData

@export var damage: float
@export var status_effects: Array[StatusEffectData]

func _init(damage_: float = 0, status_effects_: Array[StatusEffectData] = []) -> void:
	damage = damage_
	status_effects = status_effects_
