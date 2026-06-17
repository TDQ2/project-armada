extends Node2D
class_name ShipBase

var ship_data: ShipData
@onready var weapons_component: WeaponsComponent = $WeaponsComponent

func sync() -> void:
	weapons_component.sync(ship_data.weapon_slots)
