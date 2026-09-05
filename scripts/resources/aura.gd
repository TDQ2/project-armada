extends Resource
class_name AuraData

var aura_type: Data.AuraType
var shape: Data.AuraShape
var weapon_modifiers: Array[StatModifier]
# add crew and ship modifiers and validators later here

func _init(
	aura_type_: Data.AuraType,
	shape_: Data.AuraShape,
	weapon_modifiers_: Array[StatModifier]
) -> void:
	aura_type = aura_type_
	shape = shape_
	assert(validate_weapon_modifiers(weapon_modifiers_), "Attempting to create aura with invalid weapon modifiers")
	weapon_modifiers = weapon_modifiers_

func validate_weapon_modifiers(weapon_modifiers_: Array[StatModifier]) -> bool:
	for modifier in weapon_modifiers_:
		if !Data.VALID_WEAPON_ATTRIBUTES.has(modifier.attribute):
			return false
	return true
