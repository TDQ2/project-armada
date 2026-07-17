extends PanelContainer
class_name MapUI

@export var player_world_node: Node2D

var _map_horizontal_scale := 16.0
var _map_vertical_scale := 16.0

@onready var player_icon: Sprite2D = $SubViewportContainer/SubViewport/Icons/PlayerIcon

func setup(player_world_node_: Node2D) -> void:
	player_world_node = player_world_node_

func _process(_delta: float) -> void:
	if player_world_node != null:
		player_icon.global_position = Vector2(player_world_node.global_position.x / _map_horizontal_scale, player_world_node.global_position.y / _map_vertical_scale)
	
	#todo move icon to player relative position in the world
