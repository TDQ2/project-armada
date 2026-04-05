extends Node2D

var cannonball_scene = preload("res://scenes/weapons/cannonball.tscn")

func _ready() -> void:
	_connect_cannons($Ships)

func _connect_cannons(node: Node) -> void:
	if node.has_signal("shoot"):
		node.shoot.connect(handle_cannon_fire)
	for child in node.get_children():
		_connect_cannons(child)

func handle_cannon_fire(pos: Vector2, dir: Vector2) -> void:
	var cannonball = cannonball_scene.instantiate()
	cannonball.setup(pos, dir)
	$Projectiles.add_child(cannonball)
