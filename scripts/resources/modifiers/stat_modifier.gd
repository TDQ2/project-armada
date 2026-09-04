extends Resource
class_name StatModifier

var attribute: Data.StatAttribute
var operation: Data.ModifierOperation
var amount: float

func _init(
	attribute_: Data.StatAttribute,
	operation_: Data.ModifierOperation,
	amount_: float
) -> void:
	attribute = attribute_
	operation = operation_
	amount = amount_
