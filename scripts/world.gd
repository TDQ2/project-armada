extends Node2D

var player_cannonball_scene = preload("res://scenes/player_projectiles/player_cannonball.tscn")
var enemy_cannonball_scene = preload("res://scenes/enemy_projectiles/enemy_cannonball.tscn")

func _ready() -> void:
	_connect_cannons($Ships)

func _connect_cannons(node: Node) -> void:
	if node.has_signal("shoot"):
		node.shoot.connect(handle_cannon_fire)
	for child in node.get_children():
		_connect_cannons(child)

func handle_cannon_fire(source: Data.ProjectileSource, pos: Vector2, dir: Vector2) -> void:
	match source:
		Data.ProjectileSource.PLAYER: _create_player_cannonball(pos, dir)
		Data.ProjectileSource.ENEMY: _create_enemy_cannonball(pos, dir)

func _create_player_cannonball(pos: Vector2, dir: Vector2) -> void:
	var player_cannonball = player_cannonball_scene.instantiate()
	player_cannonball.setup(pos, dir)
	$Projectiles.add_child(player_cannonball)

func _create_enemy_cannonball(pos: Vector2, dir: Vector2) -> void:
	var enemy_cannonball = enemy_cannonball_scene.instantiate()
	enemy_cannonball.setup(pos, dir)
	$Projectiles.add_child(enemy_cannonball)
