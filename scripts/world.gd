extends Node2D

@onready var projectiles_container := $Projectiles

func _ready() -> void:
	WorldEvents.player_weapon_fired.connect(_handle_player_weapon_fired)

func _handle_player_weapon_fired(player_projectile_type: Data.PlayerProjectileType, pos: Vector2, direction: Vector2, on_hit: OnHitComponent) -> void:
	#print("player_weapon_fired in world")
	var projectile_scene := Data.world_player_projectiles[player_projectile_type]
	var projectile:PlayerProjectileBase = projectile_scene.instantiate()
	projectiles_container.add_child(projectile)
	projectile.setup(pos, direction, on_hit)
