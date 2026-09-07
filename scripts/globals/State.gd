extends Node

var run_state: RunState
var config: Config

func _ready() -> void:
	run_state = RunState.new()
	run_state.command_zone = CommandZone.new()
	run_state.inventory = Inventory.new()
	run_state.points_of_interest = PointsOfInterest.new()
	config = Config.new()
