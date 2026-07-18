extends Node
class_name OnHitComponent

@export var damage: float
@export var status_effects: Array[Data.StatusEffectType]
var on_hit_data: OnHitData

func _ready() -> void:
	on_hit_data = OnHitData.new(damage, status_effects)

func setup(on_hit_data_: OnHitData) -> void:
	on_hit_data = on_hit_data_
