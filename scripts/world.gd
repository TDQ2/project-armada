extends Node2D

func _ready() -> void:
	#_connect_cannons($Ships)
	WorldEvents.weapon_fired.connect(_handle_weapon_fired)
	

func _handle_weapon_fired(pos: Vector2, direction: Vector2, damage: float) -> void:
	print("player_weapon_fired in world")
	var projectile_scene := Data.world_projectiles[]

func _connect_cannons(node: Node) -> void:
	if node.has_signal("shoot"):
		node.shoot.connect(handle_cannon_fire)
	for child in node.get_children():
		_connect_cannons(child)

func handle_cannon_fire(source: Data.ProjectileSource, pos: Vector2, dir: Vector2, damage: float) -> void:
	match source:
		Data.ProjectileSource.PLAYER: _create_player_cannonball(pos, dir, damage)
		Data.ProjectileSource.ENEMY: _create_enemy_cannonball(pos, dir, damage)

func _create_player_cannonball(pos: Vector2, dir: Vector2, damage: float) -> void:
	var player_cannonball = player_cannonball_scene.instantiate()
	player_cannonball.setup(pos, dir, damage)
	$Projectiles.add_child(player_cannonball)

func _create_enemy_cannonball(pos: Vector2, dir: Vector2, damage: float) -> void:
	var enemy_cannonball = enemy_cannonball_scene.instantiate()
	enemy_cannonball.setup(pos, dir, damage)
	$Projectiles.add_child(enemy_cannonball)
