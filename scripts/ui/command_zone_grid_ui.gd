extends GridContainer

#This grid container is a frontend representation of the command zone stored in Run
@onready var command_zone := Run.command_zone

func _ready() -> void:
	_refresh_grid()
	command_zone.command_zone_changed.connect(_refresh_grid)
	for child in get_children():
		var button := child as Button
		button.pressed.connect(_on_cell_pressed.bind(button))
	
	# Add some placeholder ships and enablements
	command_zone.set_cell_ship_data(2, 2, Data.create_ship(Data.ShipType.FLAGSHIP1))
	command_zone.set_cell_ship_data(1, 1, Data.create_ship(Data.ShipType.FRIGATE))
	command_zone.set_cell_ship_data(3, 3, Data.create_ship(Data.ShipType.FRIGATE))
	command_zone.enable_cell(1, 2)
	command_zone.enable_cell(3, 2)

func _refresh_grid() -> void:
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
	var idx := button.get_index()
	var coords := _children_index_to_grid(idx)
	command_zone.select_cell(coords.x, coords.y)
	
func _children_index_to_grid(idx: int) -> Vector2i:
	@warning_ignore("integer_division")
	var row := idx / columns
	var col := idx % columns
	return Vector2i(row, col)
	
	
	
	
