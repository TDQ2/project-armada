extends Node

enum ProjectileSource {UNDEFINED, PLAYER, ENEMY}
enum ShipType {UNDEFINED, FLAGSHIP1, FRIGATE}
enum CrewType {UNDEFINED, CAPTAIN}
enum WeaponType {UNDEFINED, STARTER_CANNON, STANDARD_CANNON}
enum PlayerProjectileType {UNDEFINED, PLAYER_CANNONBALL}
enum ItemType {SHIP, CREW, WEAPON}

const SHIP_SPACING := 28
const WEAPON_UNIT_RANGE := 16

var world_ships: Dictionary[ShipType, PackedScene] = {
	ShipType.FLAGSHIP1: preload("res://scenes/player_ships/flagship_1.tscn"),
	ShipType.FRIGATE: preload("res://scenes/player_ships/frigate.tscn")
}

var world_weapons: Dictionary[WeaponType, PackedScene] = {
	WeaponType.STARTER_CANNON: preload("res://scenes/player_weapons/Children/starter_cannon.tscn"),
	WeaponType.STANDARD_CANNON: preload("res://scenes/player_weapons/children/standard_cannon.tscn")
}

var world_player_projectiles: Dictionary[PlayerProjectileType, PackedScene] = {
	PlayerProjectileType.PLAYER_CANNONBALL: preload("res://scenes/player_projectiles/children/player_cannonball.tscn")
}

func create_ship(ship_type: ShipType) -> ShipData:
	match ship_type:
		ShipType.FLAGSHIP1:
			return ShipData.new(
				ship_type,
				"Flagship", 
				true, [], 
				3, 
				[create_weapon(WeaponType.STARTER_CANNON), create_weapon(WeaponType.STANDARD_CANNON)], 
				3, 
				preload("res://textures/player_ships/flagship_ph.png"))
		ShipType.FRIGATE:
			return ShipData.new(
				ship_type, 
				"Frigate", 
				false, 
				[], 
				2, 
				[], 
				2, 
				preload("res://textures/player_ships/gunship_ph.png"))
	
	assert(false, "Attempted to create a ShipType which was not defaaaaaaaaaaained in the ship factory")
	return ShipData.new(ShipType.UNDEFINED, "Undefined", false, [], 0, [], 0, null)

func create_weapon(weapon_type: WeaponType) -> WeaponData:
	match weapon_type:
		WeaponType.STARTER_CANNON:
			return WeaponData.new(WeaponType.STARTER_CANNON, PlayerProjectileType.PLAYER_CANNONBALL, 4, 15.0, 6.0, "Starter Cannon", preload("res://textures/weapons/cannon_ph.png"))
		WeaponType.STANDARD_CANNON:
			return WeaponData.new(WeaponType.STANDARD_CANNON, PlayerProjectileType.PLAYER_CANNONBALL, 5, 20.0, 2, "Standard Cannon", preload("res://textures/weapons/cannon_ph.png"))
	
	assert(false, "Attempted to create a ShipType which was not defined in the ship factory")
	return WeaponData.new(WeaponType.UNDEFINED, PlayerProjectileType.UNDEFINED, 0, 0.0, 0.0, "", null)
