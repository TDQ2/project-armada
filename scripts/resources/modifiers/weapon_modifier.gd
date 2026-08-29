extends Resource
class_name WeaponModifier

var attribute: Data.WeaponAttribute
var operation: Data.ModifierOperations
var amount: float

func _init(
	attribute_: Data.WeaponAttribute,
	operation_: Data.ModifierOperations,
	amount_: float
) -> void:
	attribute = attribute_
	operation = operation_
	amount = amount_
