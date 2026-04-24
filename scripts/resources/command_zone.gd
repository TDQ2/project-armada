extends Resource
class_name CommandZone

signal command_zone_changed
signal cell_selected(ship_data: ShipData)

var grid: Array[Array] # of CommandZoneCell
var num_rows := 5
var num_cols := 5

var selected_cell_pos: Vector2i

func _init() -> void:
	for i in range(num_rows):
		var row: Array[CommandZoneCell] = []
		for j in range(num_cols):
			row.append(CommandZoneCell.new())
		grid.append(row)

func get_cell(row: int, col: int) -> CommandZoneCell:
	return grid[row][col] as CommandZoneCell

func _set_cell(row: int, col: int, cell_data: CommandZoneCell) -> void:
	grid[row][col] = cell_data
	command_zone_changed.emit()

func set_cell_ship_data(row: int, col: int, ship_data: ShipData) -> void:
	var cell = grid[row][col] as CommandZoneCell
	cell.disabled = false
	cell.ship = ship_data
	command_zone_changed.emit()

func enable_cell(row: int, col: int) -> void:
	var cell = grid[row][col] as CommandZoneCell
	cell.disabled = false
	command_zone_changed.emit()

func disable_cell(row: int, col: int) -> void:
	var cell = grid[row][col] as CommandZoneCell
	cell.disabled = true
	command_zone_changed.emit()

func select_cell(row: int, col: int) -> void:
	selected_cell_pos = Vector2i(row, col)
	var command_zone_cell := get_cell(row, col)
	if command_zone_cell.ship:
		cell_selected.emit(command_zone_cell.ship)
	
