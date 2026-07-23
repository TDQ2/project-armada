extends Resource
class_name PoiData

@export var position: Vector2
@export var type: Data.PoiType
@export var ships: Array[ShipData]
@export var crew: Array[CrewData]
@export var weapons: Array[WeaponData]
@export var cleared: bool


func _init(
	position_: Vector2, 
	type_: Data.PoiType,
	ships_: Array[ShipData],
	crew_: Array[CrewData],
	weapons_: Array[WeaponData],
	cleared_: bool = false) -> void:
	position = position_
	type = type_
	ships = ships_
	weapons = weapons_
	crew = crew_
	cleared = cleared_
	
