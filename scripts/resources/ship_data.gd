extends Resource
class_name ShipData

var ship_type: Data.ShipType
var name: String
var is_flagship := false
var crew_slots: Array[CrewData]
var weapon_slots: Array[WeaponData]
var ui_icon: Texture2D

func _init(ship_type_: Data.ShipType, name_: String, is_flagship_: bool, crew_slots_: Array[CrewData], weapon_slots_: Array[WeaponData], ui_icon_: Texture2D) -> void:
	ship_type = ship_type_
	name = name_
	is_flagship = is_flagship_
	crew_slots = crew_slots_
	weapon_slots = weapon_slots_
	ui_icon = ui_icon_
