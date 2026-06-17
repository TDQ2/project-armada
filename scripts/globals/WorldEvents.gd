extends Node

signal weapon_fired(projectile_type: Data.ProjectileType, pos: Vector2, direction: Vector2, damage: float)

func emit_player_weapon_fired(projectile_type: Data.ProjectileType, pos: Vector2, direction: Vector2, damage: float) -> void:
	weapon_fired.emit(pos, direction, damage)
