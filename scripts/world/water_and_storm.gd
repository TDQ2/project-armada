extends Node2D
class_name WaterAndStorm

@onready var water_tiles: WaterTiles = $WaterTiles
@onready var storm_area_2d: Area2D = $StormArea2D

var storm_top_collision: CollisionShape2D = CollisionShape2D.new()
var storm_bottom_collision: CollisionShape2D = CollisionShape2D.new()
var storm_right_collision: CollisionShape2D = CollisionShape2D.new()
var storm_left_collision: CollisionShape2D = CollisionShape2D.new()

var top_shape := RectangleShape2D.new()
var bottom_shape := RectangleShape2D.new()
var right_shape := RectangleShape2D.new()
var left_shape := RectangleShape2D.new()

var _base_left_shape_size: Vector2

func _ready() -> void:
	_set_storm_collisions()
	CommandEvents.storm_progressed.connect(_handle_storm_progression)

func setup(armada: Node2D) -> void:
	water_tiles.setup(armada)
	_handle_storm_progression(State.run_state.storm_x_idx)

func _handle_storm_progression(storm_x_index: int) -> void:
	left_shape.size = _base_left_shape_size + Vector2(Consts.TILE_FACTOR.x * 2 * (storm_x_index+1), 0)

func _set_storm_collisions() -> void:
	top_shape.size = Vector2i(Consts.STORM_BORDER_SIZE+Consts.NORMAL_WATER_SIZE.x+Consts.STORM_BORDER_SIZE, Consts.STORM_BORDER_SIZE) * Consts.TILE_FACTOR
	storm_top_collision.shape = top_shape
	storm_top_collision.position = (Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, -Consts.STORM_BORDER_SIZE)) * Consts.TILE_FACTOR + Vector2i(top_shape.size / 2)
	storm_area_2d.add_child(storm_top_collision)

	bottom_shape.size = Vector2i(Consts.STORM_BORDER_SIZE+Consts.NORMAL_WATER_SIZE.x+Consts.STORM_BORDER_SIZE, Consts.STORM_BORDER_SIZE) * Consts.TILE_FACTOR
	storm_bottom_collision.shape = bottom_shape
	storm_bottom_collision.position = (Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, Consts.NORMAL_WATER_SIZE.y)) * Consts.TILE_FACTOR  + Vector2i(bottom_shape.size / 2)
	storm_area_2d.add_child(storm_bottom_collision)

	right_shape.size = Vector2i(Consts.STORM_BORDER_SIZE, Consts.STORM_BORDER_SIZE+Consts.NORMAL_WATER_SIZE.y+Consts.STORM_BORDER_SIZE) * Consts.TILE_FACTOR
	storm_right_collision.shape = right_shape
	storm_right_collision.position = (Consts.TOP_LEFT + Vector2i(Consts.NORMAL_WATER_SIZE.x, 0)) * Consts.TILE_FACTOR  + Vector2i(right_shape.size / 2)
	storm_area_2d.add_child(storm_right_collision)
	
	_base_left_shape_size = Vector2(Consts.STORM_BORDER_SIZE, Consts.STORM_BORDER_SIZE+Consts.NORMAL_WATER_SIZE.y+Consts.STORM_BORDER_SIZE) * Vector2(Consts.TILE_FACTOR)
	left_shape.size = _base_left_shape_size
	storm_left_collision.shape = left_shape
	storm_left_collision.position = (Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, 0)) * Consts.TILE_FACTOR  + Vector2i(left_shape.size / 2)
	storm_area_2d.add_child(storm_left_collision)
