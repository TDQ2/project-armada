extends Resource
class_name Aura

var shape: Data.AuraShape
var weapon_modifiers: Array[WeaponModifier]
# add crew and ship modifiers later here

func _init(
	shape_: Data.AuraShape,
	weapon_modifiers_: Array[WeaponModifier]
) -> void:
	shape = shape_
	weapon_modifiers = weapon_modifiers_
