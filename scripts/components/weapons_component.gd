extends Node2D
class_name WeaponsComponent

signal weapon_fired(weapon_data: WeaponData)

var runtime_weapons: Dictionary[WeaponData, WeaponBase]

func sync(weapons: Array[WeaponData]) -> void:
	for weapon: WeaponData in weapons:
		if weapon == null:
			continue
		if weapon not in runtime_weapons:
			_add_weapon(weapon)
		else:
			var runtime_weapon := runtime_weapons[weapon]
			runtime_weapon.refresh()

func _add_weapon(weapon_data: WeaponData) -> void:
	#print("adding weapon data with type " + str(weapon_data.weapon_type))
	if runtime_weapons.has(weapon_data):
		print("already has weapon " + str(weapon_data))
		return
	var new_weapon_scene := Data.world_weapons[weapon_data.weapon_type]
	var new_weapon: WeaponBase = new_weapon_scene.instantiate()
	new_weapon.fired.connect(emit_weapon_fired)
	add_child(new_weapon)
	new_weapon.set_weapon_data(weapon_data)
	runtime_weapons[weapon_data] = new_weapon

func emit_weapon_fired(weapon_data: WeaponData) -> void:
	weapon_fired.emit(weapon_data)
