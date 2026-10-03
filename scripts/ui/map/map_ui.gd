class_name MapUI
extends PanelContainer


@export var player_world_node: Node2D
var _poi_data_to_icon: Dictionary[PoiData, Sprite2D]

var _map_horizontal_scale := 8.0
var _map_vertical_scale := 8.0
var _storm_base_x: float

@onready var _player_icon: Sprite2D = $SubViewportContainer/SubViewport/Icons/PlayerIcon
@onready var _icons_container: Node2D = $SubViewportContainer/SubViewport/Icons
@onready var _storm: Sprite2D = $SubViewportContainer/SubViewport/Storm
@onready var _temp_home: Sprite2D = $SubViewportContainer/SubViewport/Icons/tempCenter


func _ready() -> void:
	CommandEvents.poi_added.connect(_handle_poi_added)
	CommandEvents.poi_cleared.connect(_handle_poi_cleared)
	CommandEvents.storm_progressed.connect(_handle_storm_progression)
	_storm_base_x = _storm.position.x


func setup(player_world_node_: Node2D) -> void:
	player_world_node = player_world_node_
	_temp_home.position = _to_map_coords(player_world_node.global_position)
	_handle_storm_progression(State.run_state.storm_x_idx)


func _handle_poi_added(poi_data: PoiData) -> void:
	if poi_data.cleared:
		return
	var map_icon := Sprite2D.new()
	_icons_container.add_child(map_icon)
	map_icon.texture = Data.map_poi_icons[poi_data.type]
	map_icon.position = _to_map_coords(poi_data.position)
	_poi_data_to_icon[poi_data] = map_icon


func _handle_poi_cleared(poi_data: PoiData) -> void:
	var poi_icon = _poi_data_to_icon[poi_data]
	_poi_data_to_icon.erase(poi_data)
	poi_icon.queue_free()


func _process(_delta: float) -> void:
	if player_world_node != null:
		_player_icon.global_position = _to_map_coords(player_world_node.global_position)


func _handle_storm_progression(storm_x_idx: int) -> void:
	_storm.position.x = _storm_base_x + storm_x_idx * Consts.TILE_FACTOR.x / _map_horizontal_scale


func _to_map_coords(world_position: Vector2) -> Vector2:
	return Vector2(world_position.x / _map_horizontal_scale, world_position.y / _map_vertical_scale)
