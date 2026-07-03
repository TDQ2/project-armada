extends TileMapLayer

class CellTracker:
	var coord: Vector2i
	var timer: float
	
	func _init(coord_: Vector2i, timer_: float) -> void:
		coord = coord_
		timer = timer_

const TILE_SOURCE := 0
const ANIMATION_CHANCE := 0.1
const BASE_WATER_TILE_CHANCE := 0.7
const MIN_DURATION := 3
const MAX_DURATION := 5
const BASE_WATER_TILE_TYPE := Vector2i(0,0)

# For keeping track of which tiles are animated vs static
var _static_tiles:Array[Vector2i] = []
var _animated_tiles:Array[Vector2i] = []

var _tile_durations: Dictionary[Vector2i, float] = {
	Vector2i(0,0): 5.0, 
	Vector2i(3,0): 1.5
	}

# Keep track of when to change
var _next_change_tracker: Array[CellTracker]

func _ready() -> void:
	_classify_tile_types()
	_setup_tile_draws_and_timers()

func _process(delta: float) -> void:
	for cell_tracker in _next_change_tracker:
		cell_tracker.timer -= delta
		if cell_tracker.timer <= 0:
			var tile_type := redraw_cell_random(cell_tracker.coord)
			cell_tracker.timer = _get_interval_for_tile(tile_type)

func _classify_tile_types() -> void:
	var tile_set_source = tile_set.get_source(TILE_SOURCE) as TileSetAtlasSource
	for i in tile_set_source.get_tiles_count():
		var coord := tile_set_source.get_tile_id(i)
		if tile_set_source.get_tile_animation_frames_count(coord) > 1:
			_animated_tiles.append(coord)
		else:
			_static_tiles.append(coord)

func _setup_tile_draws_and_timers() -> void:
	var region = get_used_rect()
	for x in range(region.position.x, region.end.x):
		for y in range(region.position.y, region.end.y):
			var coord := Vector2i(x, y)
			var tile_type = redraw_cell_random(coord)
			_next_change_tracker.append(CellTracker.new(coord, _get_interval_for_tile(tile_type)))

func _get_interval_for_tile(tile_type: Vector2i) -> float:
	if tile_type in _tile_durations:
		return _tile_durations[tile_type]
	return randf_range(MIN_DURATION,MAX_DURATION)

func redraw_cell_random(coord: Vector2i) -> Vector2i: #returns tile type
	if randf() < BASE_WATER_TILE_CHANCE:
		set_cell(coord, TILE_SOURCE, BASE_WATER_TILE_TYPE)
		return BASE_WATER_TILE_TYPE
	if randf() < ANIMATION_CHANCE:
		var chosen_cell = _animated_tiles.pick_random()
		set_cell(coord, TILE_SOURCE, chosen_cell)
		return chosen_cell
	else:
		var chosen_cell = _static_tiles.pick_random()
		set_cell(coord, TILE_SOURCE, chosen_cell)
		return chosen_cell
