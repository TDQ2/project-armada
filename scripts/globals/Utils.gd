extends Node

func has_collision_shape(node: Node) -> bool:
	for child in node.get_children():
		if child is CollisionShape2D or child is CollisionPolygon2D:
			return true
	return false

func coord_is_valid(coord: Coord) -> bool:
	if coord.row < 0 or coord.col < 0 or coord.row > 4 or coord.col > 4:
		return false
	return true

# Assumes that all of the stats provided to the computation are the same e.g. all range
func compute_modified_stat(base: float, modifiers: Array[StatModifier]) -> float:
	var added_total: float = 0.0
	var mult_total: float = 1.0 # Start at one since this is percentage multiplication
	for modifier in modifiers:
		match modifier.operation:
			Data.ModifierOperation.ADD:
				added_total += modifier.amount
			Data.ModifierOperation.MULT:
				mult_total += modifier.amount
			Data.ModifierOperation.UNDEFINED:
				assert(false, "Attempting to apply undefined modifier operaiton")
			_: 
				assert(false, "Attempting to compute unimplemented modifier operation")
	if mult_total < 0:
		mult_total = 0
	var total:float = (base + added_total) * mult_total
	if total < 0:
		total = 0
	return total
