class_name WaterAndStorm
extends Node2D

var _storm_top_collision: CollisionShape2D = CollisionShape2D.new()
var _storm_bottom_collision: CollisionShape2D = CollisionShape2D.new()
var _storm_right_collision: CollisionShape2D = CollisionShape2D.new()
var _storm_left_collision: CollisionShape2D = CollisionShape2D.new()

var _top_shape := RectangleShape2D.new()
var _bottom_shape := RectangleShape2D.new()
var _right_shape := RectangleShape2D.new()
var _left_shape := RectangleShape2D.new()

var _base_left_shape_size: Vector2

@onready var water_tiles: WaterTiles = $WaterTiles
@onready var storm_area_2d: Area2D = $StormArea2D

func _ready() -> void:
	_set_storm_collisions()
	CommandEvents.storm_progressed.connect(_handle_storm_progression)


func setup(armada: Node2D) -> void:
	water_tiles.setup(armada)
	_handle_storm_progression(State.run_state.storm_x_idx)


func _handle_storm_progression(storm_x_index: int) -> void:
	_left_shape.size = (
		_base_left_shape_size + Vector2(Consts.TILE_FACTOR.x * 2 * (storm_x_index + 1), 0)
	)


func _set_storm_collisions() -> void:
	_top_shape.size = (
		Vector2i(
			Consts.STORM_BORDER_SIZE + Consts.NORMAL_WATER_SIZE.x + Consts.STORM_BORDER_SIZE,
			Consts.STORM_BORDER_SIZE
		)
		* Consts.TILE_FACTOR
	)
	_storm_top_collision.shape = _top_shape
	_storm_top_collision.position = (
		(
			(Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, -Consts.STORM_BORDER_SIZE))
			* Consts.TILE_FACTOR
		)
		+ Vector2i(_top_shape.size / 2)
	)
	storm_area_2d.add_child(_storm_top_collision)

	_bottom_shape.size = (
		Vector2i(
			Consts.STORM_BORDER_SIZE + Consts.NORMAL_WATER_SIZE.x + Consts.STORM_BORDER_SIZE,
			Consts.STORM_BORDER_SIZE
		)
		* Consts.TILE_FACTOR
	)
	_storm_bottom_collision.shape = _bottom_shape
	_storm_bottom_collision.position = (
		(
			(Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, Consts.NORMAL_WATER_SIZE.y))
			* Consts.TILE_FACTOR
		)
		+ Vector2i(_bottom_shape.size / 2)
	)
	storm_area_2d.add_child(_storm_bottom_collision)

	_right_shape.size = (
		Vector2i(
			Consts.STORM_BORDER_SIZE,
			Consts.STORM_BORDER_SIZE + Consts.NORMAL_WATER_SIZE.y + Consts.STORM_BORDER_SIZE
		)
		* Consts.TILE_FACTOR
	)
	_storm_right_collision.shape = _right_shape
	_storm_right_collision.position = (
		(Consts.TOP_LEFT + Vector2i(Consts.NORMAL_WATER_SIZE.x, 0)) * Consts.TILE_FACTOR
		+ Vector2i(_right_shape.size / 2)
	)
	storm_area_2d.add_child(_storm_right_collision)

	_base_left_shape_size = (
		Vector2(
			Consts.STORM_BORDER_SIZE,
			Consts.STORM_BORDER_SIZE + Consts.NORMAL_WATER_SIZE.y + Consts.STORM_BORDER_SIZE
		)
		* Vector2(Consts.TILE_FACTOR)
	)
	_left_shape.size = _base_left_shape_size
	_storm_left_collision.shape = _left_shape
	_storm_left_collision.position = (
		(Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, 0)) * Consts.TILE_FACTOR
		+ Vector2i(_left_shape.size / 2)
	)
	storm_area_2d.add_child(_storm_left_collision)
