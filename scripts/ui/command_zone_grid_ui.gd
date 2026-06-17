extends GridContainer

func _ready() -> void:
	CommandEvents.command_zone_changed.connect(_refresh_grid)
	for child in get_children():
		var button := child as CommandZoneButton
		button.pressed.connect(_on_cell_pressed.bind(button))
		button.coords = _get_button_coords(button)
	
	# This is dev data for testing
	Commands.add_ship_to_cz(Coords.new(2, 2), Data.create_ship(Data.ShipType.FLAGSHIP1))
	Commands.add_ship_to_cz(Coords.new(1, 1), Data.create_ship(Data.ShipType.FRIGATE))
	Commands.add_ship_to_cz(Coords.new(3, 3), Data.create_ship(Data.ShipType.FRIGATE))
	Commands.enable_cz_cell(Coords.new(1, 2))
	Commands.enable_cz_cell(Coords.new(3, 2))

func _refresh_grid(command_zone: CommandZone) -> void:
	#print("refresh cz grid")
	for i in command_zone.grid.size():
		for j in command_zone.grid[i].size():
			var coords = Coords.new(i, j)
			var backend_cell := command_zone.get_cell(coords) as CommandZoneCell
			var ui_cell = get_child(_grid_to_children_index(coords)) as Button
			_update_grid_button(ui_cell, backend_cell)

func _grid_to_children_index(coords: Coords) -> int:
	return coords.row * columns + coords.col

func _update_grid_button(ui_cell: Button, backend_cell: CommandZoneCell) -> void:
	ui_cell.disabled = backend_cell.disabled
	if backend_cell.ship:
		ui_cell.icon = backend_cell.ship.ui_icon
	else:
		ui_cell.icon = null

func _on_cell_pressed(button: Button) -> void:
	var coords := _get_button_coords(button)
	Commands.select_cell(coords)

func _get_button_coords(button: Button) -> Coords:
	var idx := button.get_index()
	return _children_index_to_grid(idx)

func _children_index_to_grid(idx: int) -> Coords:
	@warning_ignore("integer_division")
	var row := idx / columns
	var col := idx % columns
	return Coords.new(row, col)
	
	
	
	
