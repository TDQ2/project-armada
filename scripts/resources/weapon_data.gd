extends ItemData
class_name WeaponData

@export var weapon_type: Data.WeaponType
@export var player_projectile_type: Data.PlayerProjectileType
@export var fire_range: int
@export var damage: float
@export var cooldown_duration: float
@export var status_effects: Array[Data.StatusEffectType]


func _init(
	weapon_type_: Data.WeaponType, 
	player_projectile_type_: Data.PlayerProjectileType, 
	fire_range_: int, 
	damage_: float, 
	cooldown_duration_: float,
	status_effects_: Array[Data.StatusEffectType],
	name_: String, 
	ui_icon_: Texture2D) -> void:
	weapon_type = weapon_type_
	player_projectile_type = player_projectile_type_
	fire_range = fire_range_
	damage = damage_
	cooldown_duration = cooldown_duration_
	status_effects = status_effects_
	name = name_
	ui_icon = ui_icon_
	
	
