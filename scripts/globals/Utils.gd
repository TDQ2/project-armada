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
