extends TileMapLayer
class_name WaterTiles

const WATER_TILE_SOURCE := 0
const STORM_TILE_SOURCE := 1
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

# Keep track of when to change to a different random normal water cell
var _cell_update_timers: Dictionary[Vector2i, float] # float is timer duration

var armada: Node2D

### STORM Management
var storm_x_index := 0
const STORM_PROGRESSION_INTERVAL := 3
var storm_timer := 0.0
const STORM_Y_UPPER_BOUND := -200
const STORM_Y_LOWER_BOUND := 200

func _ready() -> void:
	# TODO: populate water programmatically
	_classify_water_tile_types()

func setup(armada_: Node2D) -> void:
	armada = armada_
	_set_visible_cells()

func _process(delta: float) -> void:
	storm_timer += delta
	if storm_timer >= STORM_PROGRESSION_INTERVAL:
		storm_timer -= STORM_PROGRESSION_INTERVAL
		_handle_storm_progression()
	_handle_cell_timers(delta)
	_set_visible_cells()

func _set_visible_cells() -> void:
	var curr_visible := get_visible_range()
	for x in range(curr_visible.position.x, curr_visible.end.x):
		for y in range(curr_visible.position.y, curr_visible.end.y):
			var cell := Vector2i(x, y)
			if get_cell_source_id(Vector2i(x, y)) == WATER_TILE_SOURCE and !_cell_update_timers.has(cell):
				var tile_type := _redraw_cell_random(cell)
				_cell_update_timers[cell] = _get_interval_for_tile(tile_type)

func _handle_cell_timers(delta: float) -> void:
	var cells_to_erase: Array[Vector2i]
	for cell: Vector2i in _cell_update_timers:
		var curr_visible := get_visible_range()
		_cell_update_timers[cell] -= delta
		if _cell_update_timers[cell] <= 0:
			if curr_visible.has_point(cell):
				var tile_type := _redraw_cell_random(cell)
				_cell_update_timers[cell] = _get_interval_for_tile(tile_type)
			else:
				cells_to_erase.append(cell)
	for cell in cells_to_erase:
		_cell_update_timers.erase(cell)

# This method determines if the normal water types are animated or static
func _classify_water_tile_types() -> void:
	var tile_set_source = tile_set.get_source(WATER_TILE_SOURCE) as TileSetAtlasSource
	for i in tile_set_source.get_tiles_count():
		var coord := tile_set_source.get_tile_id(i)
		if tile_set_source.get_tile_animation_frames_count(coord) > 1:
			_animated_tiles.append(coord)
		else:
			_static_tiles.append(coord)

func _update_timers(region: Rect2i) -> void:
	for x in range(region.position.x, region.end.x):
		for y in range(region.position.y, region.end.y):
			if !_cell_update_timers.has(Vector2i(x, y)):
				var coord := Vector2i(x, y)
				var tile_type := _redraw_cell_random(coord)
				_cell_update_timers[Vector2i(x, y)] = _get_interval_for_tile(tile_type)

func _get_interval_for_tile(tile_type: Vector2i) -> float:
	if tile_type in _tile_durations:
		return _tile_durations[tile_type]
	return randf_range(MIN_DURATION,MAX_DURATION)

func _redraw_cell_random(coord: Vector2i) -> Vector2i: #returns tile type
	if randf() < BASE_WATER_TILE_CHANCE:
		set_cell(coord, WATER_TILE_SOURCE, BASE_WATER_TILE_TYPE)
		return BASE_WATER_TILE_TYPE
	if randf() < ANIMATION_CHANCE:
		var chosen_cell = _animated_tiles.pick_random()
		set_cell(coord, WATER_TILE_SOURCE, chosen_cell)
		return chosen_cell
	else:
		var chosen_cell = _static_tiles.pick_random()
		set_cell(coord, WATER_TILE_SOURCE, chosen_cell)
		return chosen_cell

func _handle_storm_progression() -> void:
	for i in range(STORM_Y_UPPER_BOUND, STORM_Y_LOWER_BOUND+1):
		set_cell(Vector2i(storm_x_index, i), STORM_TILE_SOURCE, Vector2i(0,0))
	var cells_to_erase: Array[Vector2i]
	for cell: Vector2i in _cell_update_timers:
		if cell.x == storm_x_index:
			cells_to_erase.append(cell)
	for cell: Vector2i in cells_to_erase:
		_cell_update_timers.erase(cell)
	storm_x_index += 1

func get_visible_range() -> Rect2i:
	# if armada position is 0,0
	# return a square that surrounds the armada in all directions by the x and y offsets
	# for example x_offset = 3, y_offset = 2
	# box would be top left corner = -3, -2 and top right corner would be = 3, 2
	var armada_local_pos := to_local(armada.global_position)
	var armada_map_coord := local_to_map(armada_local_pos)
	var x_offset := 30
	var y_offset := 16
	var visible_area = Rect2i(
		Vector2i(armada_map_coord.x - x_offset, armada_map_coord.y - y_offset), # start position
		Vector2i(x_offset*2+1, y_offset*2+1) # size
		)
	return visible_area
