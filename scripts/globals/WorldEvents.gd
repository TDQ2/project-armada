extends Node

signal player_weapon_fired(projectile_type: Data.PlayerProjectileType, pos: Vector2, direction: Vector2, on_hit: OnHitComponent)

func emit_player_weapon_fired(
	projectile_type: Data.PlayerProjectileType, 
	pos: Vector2, 
	direction: Vector2, 
	on_hit: OnHitComponent) -> void:
	player_weapon_fired.emit(projectile_type, pos, direction, on_hit)
