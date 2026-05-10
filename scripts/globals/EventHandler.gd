extends Node

# This class handle user inputs like an API
# Updates Run state
# Tells the Notifier to emit presentation related signals

signal select_cell(row: int, col: int)

func _ready() -> void:
	pass

#func _handle_select_cell(row: int, col: int) -> void:
	#var command_zone_cell := Run.command_zone.get_cell(row, col)
	#if command_zone_cell.ship:
		#cell_selected.emit(command_zone_cell.ship)
