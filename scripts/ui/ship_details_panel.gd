extends PanelContainer

@onready var command_zone = Run.command_zone

func _ready() -> void:
	Run.command_zone.cell_selected.connect(_update_ship_details)
	
func _update_ship_details(ship_data: ShipData) -> void:
	print("Update ship details" + str(ship_data))
	$ShipDetailsContainer/ShipName.text = ship_data.name
