class_name WaterTiles
extends TileMapLayer


const WATER_TILE_SOURCE := 0
const STORM_TILE_SOURCE := 1

# Tile randomization consts
const ANIMATION_CHANCE := 0.1
const BASE_WATER_TILE_CHANCE := 0.7
const MIN_DURATION := 3
const MAX_DURATION := 5
const BASE_WATER_TILE_TYPE := Vector2i(0, 0)

### STORM Management provided by parent
const STORM_Y_UPPER_BOUND := Consts.TOP_LEFT.y
const STORM_Y_LOWER_BOUND := Consts.TOP_LEFT.y + Consts.NORMAL_WATER_SIZE.y

# For keeping track of which tiles are animated vs static
var _static_tiles: Array[Vector2i] = []
var _animated_tiles: Array[Vector2i] = []

var _tile_durations: Dictionary[Vector2i, float] = {Vector2i(0, 0): 5.0, Vector2i(3, 0): 1.5}

# Keep track of when to change to a different random normal water cell
var _cell_update_timers: Dictionary[Vector2i, float]  # float is timer duration
var _armada: Node2D

func _ready() -> void:
	# TODO: populate water programmatically
	CommandEvents.storm_progressed.connect(_progress_storm_tiles)
	_classify_water_tile_types()
	_set_base_water_tiles()
	_set_storm_water_tiles()
	set_process(false)  # prevents processing before armada is set


func _set_base_water_tiles() -> void:
	for x in range(Consts.NORMAL_WATER_SIZE.x):
		for y in range(Consts.NORMAL_WATER_SIZE.y):
			var coord := Consts.TOP_LEFT + Vector2i(x, y)
			set_cell(coord, 0, Vector2i(0, 0))  # set cell to default water tile


func _set_storm_water_tiles() -> void:
	var top_left_storm := (
		Consts.TOP_LEFT + Vector2i(-Consts.STORM_BORDER_SIZE, -Consts.STORM_BORDER_SIZE)
	)
	var normal_water_region := Rect2i(Consts.TOP_LEFT, Consts.NORMAL_WATER_SIZE)
	for x in range(
		top_left_storm.x, Consts.TOP_LEFT.x + Consts.NORMAL_WATER_SIZE.x + Consts.STORM_BORDER_SIZE
	):
		for y in range(
			top_left_storm.y,
			Consts.TOP_LEFT.y + Consts.NORMAL_WATER_SIZE.y + Consts.STORM_BORDER_SIZE
		):
			var coord := Vector2i(x, y)
			if !normal_water_region.has_point(coord):
				set_cell(coord, 1, Vector2i(0, 0))  # set cell to default storm tile


func setup(armada_: Node2D) -> void:
	_armada = armada_

	_set_visible_cells()
	_progress_storm_tiles(State.run_state.storm_x_idx)
	set_process(true)  # prevents processing before _armada is set


func _process(delta: float) -> void:
	_handle_cell_timers(delta)
	_set_visible_cells()


func _set_visible_cells() -> void:
	var curr_visible := get_visible_range()
	for x in range(curr_visible.position.x, curr_visible.end.x):
		for y in range(curr_visible.position.y, curr_visible.end.y):
			var cell := Vector2i(x, y)
			if (
				get_cell_source_id(Vector2i(x, y)) == WATER_TILE_SOURCE
				and !_cell_update_timers.has(cell)
			):
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


func _get_interval_for_tile(tile_type: Vector2i) -> float:
	if tile_type in _tile_durations:
		return _tile_durations[tile_type]
	return randf_range(MIN_DURATION, MAX_DURATION)


func _redraw_cell_random(coord: Vector2i) -> Vector2i:  #returns tile type
	if randf() < BASE_WATER_TILE_CHANCE:
		set_cell(coord, WATER_TILE_SOURCE, BASE_WATER_TILE_TYPE)
		return BASE_WATER_TILE_TYPE
	if randf() < ANIMATION_CHANCE:
		var animated_chosen_cell = _animated_tiles.pick_random()
		set_cell(coord, WATER_TILE_SOURCE, animated_chosen_cell)
		return animated_chosen_cell
	var static_chosen_cell = _static_tiles.pick_random()
	set_cell(coord, WATER_TILE_SOURCE, static_chosen_cell)
	return static_chosen_cell


func _progress_storm_tiles(storm_x_index: int) -> void:
	for i in range(STORM_Y_UPPER_BOUND, STORM_Y_LOWER_BOUND + 1):
		set_cell(Vector2i(storm_x_index, i), STORM_TILE_SOURCE, Vector2i(0, 0))
	var cells_to_erase: Array[Vector2i]
	for cell: Vector2i in _cell_update_timers:
		if cell.x == storm_x_index:
			cells_to_erase.append(cell)
	for cell: Vector2i in cells_to_erase:
		_cell_update_timers.erase(cell)


func get_visible_range() -> Rect2i:
	# if _armada position is 0,0
	# return a square that surrounds the _armada in all directions by the x and y offsets
	# for example x_offset = 3, y_offset = 2
	# box would be top left corner = -3, -2 and top right corner would be = 3, 2
	var armada_local_pos := to_local(_armada.global_position)
	var armada_map_coord := local_to_map(armada_local_pos)
	var x_offset := 30
	var y_offset := 16
	var visible_area = Rect2i(
		Vector2i(armada_map_coord.x - x_offset, armada_map_coord.y - y_offset),  # start position
		Vector2i(x_offset * 2 + 1, y_offset * 2 + 1)  # size
	)
	return visible_area
