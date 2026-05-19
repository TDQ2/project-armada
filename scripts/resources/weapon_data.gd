extends ItemData
class_name WeaponData

@export var weapon_type: Data.WeaponType

func _init(weapon_type_: Data.WeaponType, name_: String, ui_icon_: Texture2D) -> void:
	weapon_type = weapon_type_
	name = name_
	ui_icon = ui_icon_
	
