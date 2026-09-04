extends Node

@onready var command_zone: CommandZone = State.run_state.command_zone

func _ready() -> void:
	CommandEvents.command_zone_changed.connect(_handle_command_zone_changed)

func _handle_command_zone_changed(command_zone_: CommandZone) -> void:
	command_zone = command_zone_
	_clear_modifiers()
	_apply_all_auras()
	_emit_ship_updates()

func _clear_modifiers() -> void:
	for i in command_zone.grid.size():
		for j in command_zone.grid[i].size():
			var coord = Coord.new(i, j)
			var cell := command_zone.get_cell(coord) as CommandZoneCell
			if cell.ship != null:
				_clear_weapon_modifiers(cell.ship)
				# TODO: implement clearning ship and crew modifiers when available

func _clear_weapon_modifiers(ship: ShipData) -> void:
	for weapon_data: WeaponData in ship.weapon_slots:
		if weapon_data != null:
			weapon_data.granted_modifiers = []

func _apply_all_auras() -> void:
	for i in command_zone.grid.size():
		for j in command_zone.grid[i].size():
			var coord = Coord.new(i, j)
			var cell := command_zone.get_cell(coord) as CommandZoneCell
			if cell.ship != null and !cell.ship.auras.is_empty():
				_apply_auras_from_ship(cell.ship, coord)

func _apply_auras_from_ship(provider_ship: ShipData, coord: Coord) -> void:
	for aura: Aura in provider_ship.auras:
		var targeted_ships: Array[ShipData] = _get_aura_targeted_ships(aura, coord)
		if !aura.weapon_modifiers.is_empty():
			_apply_weapon_aura_modifier(targeted_ships, aura.weapon_modifiers)

func _get_aura_targeted_ships(aura: Aura, coord: Coord) -> Array[ShipData]:
	var targeted_ships: Array[ShipData] = []
	match aura.shape:
		Data.AuraShape.ADJACENT:
			targeted_ships = _get_adjacent_ships(coord)
		Data.AuraShape.FRONT_BACK:
			assert(false, "front-back not implemented")
		Data.AuraShape.SIDE_SIDE:
			assert(false, "side-side not implemented")
		Data.AuraShape.UNDEFINED:
			assert(false, "Attempting to apply undefined aura shape")
	return targeted_ships

func _get_adjacent_ships(aura_coord: Coord) -> Array[ShipData]:
	var adjacent_ships: Array[ShipData] = []
	var potential_coords: Array[Coord]
	potential_coords.append(Coord.new(aura_coord.row - 1, aura_coord.col))
	potential_coords.append(Coord.new(aura_coord.row + 1, aura_coord.col))
	potential_coords.append(Coord.new(aura_coord.row, aura_coord.col - 1))
	potential_coords.append(Coord.new(aura_coord.row, aura_coord.col + 1))
	for potenial_coord in potential_coords:
		if Utils.coord_is_valid(potenial_coord): 
			# Maybe this coord check isn't needed because a ship wouldn't be
			# retrieved anyway
			var cell := command_zone.get_cell(potenial_coord)
			if cell.ship != null:
				adjacent_ships.append(cell.ship)
	return adjacent_ships

func _apply_weapon_aura_modifier(
	targeted_ships: Array[ShipData], 
	weapon_modifiers: Array[StatModifier]) -> void:
		for ship in targeted_ships:
			for weapon_data: WeaponData in ship.weapon_slots:
				if weapon_data != null:
					weapon_data.granted_modifiers.append_array(weapon_modifiers.duplicate(true))

func _emit_ship_updates() -> void:
	for i in command_zone.grid.size():
		for j in command_zone.grid[i].size():
			var coord = Coord.new(i, j)
			var cell := command_zone.get_cell(coord) as CommandZoneCell
			if cell.ship != null:
				CommandEvents.emit_ship_updated(cell.ship)
