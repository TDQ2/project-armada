extends Node2D

@onready var projectiles_container := $Projectiles
@onready var poi_container := $POIs
@onready var map_ui: MapUI = $CanvasLayer/GameplayUI/VBoxContainer/MapUI
@onready var armada: Node2D = $Armada

var poi_data_to_world: Dictionary[PoiData, PoiBase]

func _ready() -> void:
	WorldEvents.player_weapon_fired.connect(_handle_player_weapon_fired)
	WorldEvents.enemy_weapon_fired.connect(_handle_enemy_weapon_fired)
	CommandEvents.poi_added.connect(_handle_poi_added)
	#var poi_datas = _create_pois()
	map_ui.setup(armada)
	_create_pois()
	

func _create_pois() -> void:
	#TODO eventually place random POI generation here
	var poi_data := Data.create_poi(Data.PoiType.TREASURE, Vector2(200, -550))
	Commands.add_poi(poi_data)

func _handle_player_weapon_fired(player_projectile_type: Data.PlayerProjectileType, pos: Vector2, direction: Vector2, on_hit: OnHitData) -> void:
	#print("player_weapon_fired in world")
	var projectile_scene := Data.world_player_projectiles[player_projectile_type]
	var projectile:PlayerProjectileBase = projectile_scene.instantiate()
	projectiles_container.add_child(projectile)
	projectile.setup(pos, direction, on_hit)

func _handle_enemy_weapon_fired(player_projectile_type: Data.EnemyProjectileType, pos: Vector2, direction: Vector2, on_hit: OnHitData) -> void:
	#print("player_weapon_fired in world")
	var projectile_scene := Data.world_enemy_projectiles[player_projectile_type]
	var projectile:EnemyProjectileBase = projectile_scene.instantiate()
	projectiles_container.add_child(projectile)
	projectile.setup(pos, direction, on_hit)

func _handle_poi_added(poi_data: PoiData) -> void:
	var poi_scene := Data.world_pois[poi_data.type]
	var poi: PoiBase = poi_scene.instantiate()
	poi_container.add_child(poi)
	poi.setup(poi_data)
	poi_data_to_world[poi_data] = poi
