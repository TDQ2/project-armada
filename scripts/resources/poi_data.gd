extends Resource
class_name PoiData

@export var position: Vector2
@export var type: Data.PoiType
@export var cleared: bool

func _init(
	position_: Vector2, 
	type_: Data.PoiType, 
	cleared_: bool = false) -> void:
	position = position_
	type = type_
	cleared = cleared_
	
