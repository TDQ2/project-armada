extends Resource
class_name CommandZone

@export var grid: Array[Array] # of CommandZoneCell
var num_rows := 5
var num_cols := 5

var selected_cell_pos: Vector2i

func _init() -> void:
	for i in range(num_rows):
		var row: Array[CommandZoneCell] = []
		for j in range(num_cols):
			row.append(CommandZoneCell.new())
		grid.append(row)

func get_cell(coords: Coords) -> CommandZoneCell:
	return grid[coords.row][coords.col] as CommandZoneCell

func set_cell(coords: Coords, cell_data: CommandZoneCell) -> void:
	grid[coords.row][coords.col] = cell_data

func set_cell_ship_data(coords: Coords, ship_data: ShipData) -> void:
	var cell = grid[coords.row][coords.col] as CommandZoneCell
	cell.disabled = false
	cell.ship = ship_data

func enable_cell(coords: Coords) -> void:
	var cell = grid[coords.row][coords.col] as CommandZoneCell
	cell.disabled = false

func disable_cell(coords: Coords) -> void:
	var cell = grid[coords.row][coords.col] as CommandZoneCell
	cell.disabled = true
