extends Node2D
class_name WaterAndStorm

@onready var water_tiles: WaterTiles = $WaterTiles
@onready var storm_area_2d: Area2D = $StormArea2D

# Base water dimensions as tiles (currently 32x32)
const TOP_LEFT := Vector2i(0, -200)
const NORMAL_WATER_SIZE := Vector2i(400, 400)
const STORM_BORDER_SIZE := 50
const TILE_FACTOR := Vector2i(32, 32)

var storm_top_collision: CollisionShape2D = CollisionShape2D.new()
var storm_bottom_collision: CollisionShape2D = CollisionShape2D.new()
var storm_right_collision: CollisionShape2D = CollisionShape2D.new()
var storm_left_collision: CollisionShape2D = CollisionShape2D.new()

func _ready() -> void:
	_set_storm_collisions()

func _set_storm_collisions() -> void:
	var top_shape = RectangleShape2D.new()
	top_shape.size = Vector2i(STORM_BORDER_SIZE+NORMAL_WATER_SIZE.x+STORM_BORDER_SIZE, STORM_BORDER_SIZE) * TILE_FACTOR
	storm_top_collision.shape = top_shape
	storm_top_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, -STORM_BORDER_SIZE)) * TILE_FACTOR + Vector2i(top_shape.size / 2)
	storm_area_2d.add_child(storm_top_collision)
	
	var bottom_shape = RectangleShape2D.new()
	bottom_shape.size = Vector2i(STORM_BORDER_SIZE+NORMAL_WATER_SIZE.x+STORM_BORDER_SIZE, STORM_BORDER_SIZE) * TILE_FACTOR
	storm_bottom_collision.shape = bottom_shape
	storm_bottom_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, NORMAL_WATER_SIZE.y)) * TILE_FACTOR  + Vector2i(bottom_shape.size / 2)
	storm_area_2d.add_child(storm_bottom_collision)
	
	var right_shape = RectangleShape2D.new()
	right_shape.size = Vector2i(STORM_BORDER_SIZE, STORM_BORDER_SIZE+NORMAL_WATER_SIZE.y+STORM_BORDER_SIZE) * TILE_FACTOR
	storm_right_collision.shape = right_shape
	storm_right_collision.position = (TOP_LEFT + Vector2i(NORMAL_WATER_SIZE.x, 0)) * TILE_FACTOR  + Vector2i(right_shape.size / 2)
	storm_area_2d.add_child(storm_right_collision)
	
	var left_shape = RectangleShape2D.new()
	left_shape.size = Vector2i(STORM_BORDER_SIZE, STORM_BORDER_SIZE+NORMAL_WATER_SIZE.y+STORM_BORDER_SIZE) * TILE_FACTOR
	storm_left_collision.shape = left_shape
	storm_left_collision.position = (TOP_LEFT + Vector2i(-STORM_BORDER_SIZE, 0)) * TILE_FACTOR  + Vector2i(left_shape.size / 2)
	storm_area_2d.add_child(storm_left_collision)

func setup(armada: Node2D) -> void:
	water_tiles.setup(armada)
