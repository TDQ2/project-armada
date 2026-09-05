extends Resource
class_name ShipData

@export var ship_type: Data.ShipType
@export var name: String
@export var is_flagship := false
@export var crew_slots: Array[CrewData]
@export var weapon_slots: Array[WeaponData]
@export var ui_icon: Texture2D
@export var portrait: Texture2D
@export var auras: Array[AuraData]

func _init(
	ship_type_: Data.ShipType, 
	name_: String, 
	is_flagship_: bool, 
	crew_slots_: Array[CrewData], 
	crew_count: int, 
	weapon_slots_: Array[WeaponData], 
	weapon_count: int, 
	ui_icon_: Texture2D,
	portrait_: Texture2D,
	auras_: Array[AuraData]
	) -> void:
	ship_type = ship_type_
	name = name_
	is_flagship = is_flagship_
	crew_slots = crew_slots_
	crew_slots.resize(crew_count)
	weapon_slots = weapon_slots_
	weapon_slots.resize(weapon_count)
	ui_icon = ui_icon_
	portrait = portrait_
	auras = auras_
