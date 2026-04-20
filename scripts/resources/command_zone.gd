extends Resource
class_name CommandZone

signal command_zone_changed

var grid: Array[Array] # of CommandZoneCell

func _init() -> void:
	for i in range(5):
		var row: Array[CommandZoneCell] = []
		for j in range(5):
			row.append(CommandZoneCell.new())
		grid.append(row)

func get_cell(row: int, col: int) -> CommandZoneCell:
	return grid[row][col] as CommandZoneCell

func set_cell(row: int, col: int, cell_data: CommandZoneCell) -> void:
	grid[row][col] = cell_data
