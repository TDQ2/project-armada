extends GridContainer

func _ready() -> void:
	Events.command_zone_changed.connect(_refresh_grid)
	for child in get_children():
		var button := child as CommandZoneButton
		button.pressed.connect(_on_cell_pressed.bind(button))
		button.coords = _get_button_coords(button)
	
	# This is dev data for testing
	Commands.add_ship_to_cz(2, 2, Data.create_ship(Data.ShipType.FLAGSHIP1))
	Commands.add_ship_to_cz(1, 1, Data.create_ship(Data.ShipType.FRIGATE))
	Commands.add_ship_to_cz(3, 3, Data.create_ship(Data.ShipType.FRIGATE))
	Commands.enable_cz_cell(1, 2)
	Commands.enable_cz_cell(3, 2)

func _refresh_grid(command_zone: CommandZone) -> void:
	print("refresh cz grid")
	for i in command_zone.grid.size():
		for j in command_zone.grid[i].size():
			var backend_cell := command_zone.get_cell(i, j) as CommandZoneCell
			var ui_cell = get_child(_grid_to_children_index(i, j)) as Button
			_update_grid_button(ui_cell, backend_cell)

func _grid_to_children_index(row: int, col: int) -> int:
	return row * columns + col

func _update_grid_button(ui_cell: Button, backend_cell: CommandZoneCell) -> void:
	ui_cell.disabled = backend_cell.disabled
	if backend_cell.ship:
		ui_cell.icon = backend_cell.ship.ui_icon
	else:
		ui_cell.icon = null

func _on_cell_pressed(button: Button) -> void:
	var coords := _get_button_coords(button)
	#command_zone.select_cell(coords.x, coords.y)
	Commands.select_cell(coords.x, coords.y)

func _get_button_coords(button: Button) -> Vector2i:
	var idx := button.get_index()
	return _children_index_to_grid(idx)

func _children_index_to_grid(idx: int) -> Vector2i:
	@warning_ignore("integer_division")
	var row := idx / columns
	var col := idx % columns
	return Vector2i(row, col)
	
	
	
	
