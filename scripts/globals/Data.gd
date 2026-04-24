extends Node

enum ProjectileSource {UNDEFINED, PLAYER, ENEMY}
enum ShipType {UNDEFINED, FLAGSHIP1, FRIGATE}
enum CrewType {UNDEFINED, CAPTAIN}
enum WeaponType {UNDEFINED, CANNON}



func create_ship(ship_type: ShipType) -> ShipData:
	match ship_type:
		ShipType.FLAGSHIP1:
			return ShipData.new(ship_type, "Flagship", true, [], [], preload("res://textures/player_ships/flagship_ph.png"))
		ShipType.FRIGATE:
			return ShipData.new(ship_type, "Frigate", false, [], [], preload("res://textures/player_ships/gunship_ph.png"))
	
	assert(false, "Attempted to create a ShipType which was not defined in the ship factory")
	return ShipData.new(ShipType.UNDEFINED, "Undefined", false, [], [], null)

func create_weapon(weapon_type: WeaponType) -> WeaponData:
	match weapon_type:
		WeaponType.CANNON:
			return WeaponData.new(WeaponType.CANNON, "Cannon", preload("res://textures/weapons/cannon_ph.png"))
	
	assert(false, "Attempted to create a ShipType which was not defined in the ship factory")
	return WeaponData.new(WeaponType.UNDEFINED, "", null)
