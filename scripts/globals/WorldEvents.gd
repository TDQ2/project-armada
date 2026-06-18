extends Node

signal player_weapon_fired(projectile_type: Data.PlayerProjectileType, pos: Vector2, direction: Vector2, damage: float)

func emit_player_weapon_fired(projectile_type: Data.PlayerProjectileType, pos: Vector2, direction: Vector2, damage: float) -> void:
	player_weapon_fired.emit(projectile_type, pos, direction, damage)
