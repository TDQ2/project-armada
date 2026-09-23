extends Node2D
class_name WaterAndStorm

@onready var water_tiles: WaterTiles = $WaterTiles
@onready var storm_area_2d: Area2D = $StormArea2D

# Base water dimensions as tiles (currently 32x32)
const TOP_LEFT := Vector2i(0, -200)
const NORMAL_WATER_SIZE := Vector2i(400, 400)
const STORM_BORDER_SIZE := 50
const TILE_FACTOR := Vector2i(32, 32)

var storm_x_index := 0
const STORM_PROGRESSION_INTERVAL := 3
var storm_timer := 0.0

var storm_top_collision: CollisionShape2D = CollisionShape2D.new()
var storm_bottom_collision: CollisionShape2D = CollisionShape2D.new()
var storm_right_collision: CollisionShape2D = CollisionShape2D.new()
var storm_left_collision: CollisionShape2D = CollisionShape2D.new()

var top_shape = RectangleShape2D.new()
var bottom_shape = RectangleShape2D.new()
var right_shape = RectangleShape2D.new()
var left_shape = RectangleShape2D.new()

func _ready() -> void:
	_set_storm_collisions()

func _process(delta: float) -> void:
	storm_timer += delta
	if storm_timer >= STORM_PROGRESSION_INTERVAL:
		storm_timer -= STORM_PROGRESSION_INTERVAL
		_handle_storm_progression()

func _handle_storm_progression() -> void:
	water_tiles.progress_storm_tiles(storm_x_index)
	left_shape.size += Vector2(TILE_FACTOR.x * 2, 0)
	storm_x_index += 1

func _set_storm_collisions() -> void:
	top_shape.size = Vector2i(STORM_BORDER_SIZE+NORMAL_WATER_SIZE.x+STORM_BORDER_SIZE, STORM_BORDER_SIZE) * TILE_FACTOR
	storm_top_collision.shape = top_shape
	storm_top_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, -STORM_BORDER_SIZE)) * TILE_FACTOR + Vector2i(top_shape.size / 2)
	storm_area_2d.add_child(storm_top_collision)

	bottom_shape.size = Vector2i(STORM_BORDER_SIZE+NORMAL_WATER_SIZE.x+STORM_BORDER_SIZE, STORM_BORDER_SIZE) * TILE_FACTOR
	storm_bottom_collision.shape = bottom_shape
	storm_bottom_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, NORMAL_WATER_SIZE.y)) * TILE_FACTOR  + Vector2i(bottom_shape.size / 2)
	storm_area_2d.add_child(storm_bottom_collision)

	right_shape.size = Vector2i(STORM_BORDER_SIZE, STORM_BORDER_SIZE+NORMAL_WATER_SIZE.y+STORM_BORDER_SIZE) * TILE_FACTOR
	storm_right_collision.shape = right_shape
	storm_right_collision.position = (TOP_LEFT + Vector2i(NORMAL_WATER_SIZE.x, 0)) * TILE_FACTOR  + Vector2i(right_shape.size / 2)
	storm_area_2d.add_child(storm_right_collision)
	
	left_shape.size = Vector2i(STORM_BORDER_SIZE, STORM_BORDER_SIZE+NORMAL_WATER_SIZE.y+STORM_BORDER_SIZE) * TILE_FACTOR
	storm_left_collision.shape = left_shape
	storm_left_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, 0)) * TILE_FACTOR  + Vector2i(left_shape.size / 2)
	storm_area_2d.add_child(storm_left_collision)

func setup(armada: Node2D) -> void:
	water_tiles.setup(armada, TOP_LEFT.y, TOP_LEFT.y + NORMAL_WATER_SIZE.y)
