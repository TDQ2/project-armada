extends Resource
class_name Coords

@export var row: int
@export var col: int

func _init(_row: int, _col: int) -> void:
	row = _row
	col = _col
