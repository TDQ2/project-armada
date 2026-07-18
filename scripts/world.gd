extends Node2D

@onready var projectiles_container := $Projectiles
@onready var map_ui: MapUI = $CanvasLayer/GameplayUI/VBoxContainer/MapUI
@onready var armada: Node2D = $Armada

func _ready() -> void:
	WorldEvents.player_weapon_fired.connect(_handle_player_weapon_fired)
	WorldEvents.enemy_weapon_fired.connect(_handle_enemy_weapon_fired)
	map_ui.setup(armada)

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
