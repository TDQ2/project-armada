extends Node2D

@export var speed := 50
@export var rotation_speed := 0.01 # radians per second

var direction := Vector2.UP

var runtime_ship_map: Dictionary[ShipData, ShipBase]

func _ready() -> void:
	CommandEvents.command_zone_changed.connect(_handle_command_zone_update)
	_handle_command_zone_update(State.run_state.command_zone)
	CommandEvents.ship_updated.connect(_handle_ship_update)

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta: float) -> void:
	if Input.is_action_pressed("left"):
		direction = direction.rotated(-rotation_speed)
	elif Input.is_action_pressed("right"):
		direction = direction.rotated(rotation_speed)
	var velocity := direction * speed
	position += velocity * delta
	rotation = velocity.angle() + PI / 2

func _handle_command_zone_update(command_zone: CommandZone) -> void:
	var current_ships: Dictionary[ShipData, ShipBase] = {}
	for world_ship: ShipBase in $Ships.get_children():
		current_ships[world_ship.ship_data] = world_ship
	
	var updated_positions: Dictionary[ShipData, Coords] = {}
	for row in command_zone.grid.size():
		for col in command_zone.grid[row].size():
			var coords := Coords.new(row, col)
			var cell := command_zone.get_cell(coords)
			if cell.ship:
				updated_positions[cell.ship] = coords
	
	for ship_data: ShipData in updated_positions.keys():
		var new_pos := _calculate_ship_position(updated_positions[ship_data], State.run_state.flagship_coords)
		if ship_data in current_ships:
			current_ships[ship_data].position = new_pos
		else:
			_add_ship(ship_data, new_pos)
	
	# TODO: handle removing a ship

func _add_ship(ship_data: ShipData, pos: Vector2) -> void:
	var new_ship_scene := Data.world_ships[ship_data.ship_type]
	var new_ship: ShipBase = new_ship_scene.instantiate()
	new_ship.ship_data = ship_data
	$Ships.add_child(new_ship)
	new_ship.sync()
	new_ship.position = pos
	runtime_ship_map[ship_data] = new_ship

func _calculate_ship_position(ship_coords: Coords, flagship_coords: Coords) -> Vector2:
	 # (x, y) = col, row
	var coords_vector := Vector2(ship_coords.col - flagship_coords.col, ship_coords.row - flagship_coords.row)
	var armada_local_vector := coords_vector * Data.SHIP_SPACING
	return armada_local_vector

func _handle_ship_update(ship_data: ShipData) -> void:
	assert(runtime_ship_map[ship_data])
	runtime_ship_map[ship_data].sync()
