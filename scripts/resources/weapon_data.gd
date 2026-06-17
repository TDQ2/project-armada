extends ItemData
class_name WeaponData

@export var weapon_type: Data.WeaponType
@export var fire_range: int
@export var damage: float
@export var cooldown_duration: float

func _init(weapon_type_: Data.WeaponType, fire_range_: int, damage_: float, cooldown_duration_: float, name_: String, ui_icon_: Texture2D) -> void:
	weapon_type = weapon_type_
	fire_range = fire_range_
	damage = damage_
	cooldown_duration = cooldown_duration_
	name = name_
	ui_icon = ui_icon_
	
