extends PanelContainer
class_name MapUI

@export var player_world_node: Node2D
var poi_data_to_icon: Dictionary[PoiData, Sprite2D]

var _map_horizontal_scale := 8.0
var _map_vertical_scale := 8.0

@onready var player_icon: Sprite2D = $SubViewportContainer/SubViewport/Icons/PlayerIcon
@onready var icons_container: Node2D = $SubViewportContainer/SubViewport/Icons

func _ready() -> void:
	CommandEvents.poi_added.connect(_handle_add_poi)

func setup(player_world_node_: Node2D) -> void:
	player_world_node = player_world_node_

func _process(_delta: float) -> void:
	if player_world_node != null:
		player_icon.global_position = Vector2(player_world_node.global_position.x / _map_horizontal_scale, player_world_node.global_position.y / _map_vertical_scale)

func _handle_add_poi(poi_data: PoiData) -> void:
	var map_icon := Sprite2D.new()
	icons_container.add_child(map_icon)
	map_icon.texture = Data.map_poi_icons[poi_data.type]
	map_icon.position = Vector2(poi_data.position.x / _map_horizontal_scale, poi_data.position.y / _map_vertical_scale)
	poi_data_to_icon[poi_data] = map_icon
