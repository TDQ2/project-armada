extends PanelContainer

var crew_buttons:Array[Button]
var weapon_buttons:Array[Button]

func _ready() -> void:
	crew_buttons.assign($ShipDetailsContainer/GridContainer/CrewButtons.get_children())
	weapon_buttons.assign($ShipDetailsContainer/GridContainer/WeaponButtons.get_children())
	
	#signals
	Events.cz_cell_selected.connect(_update_ship_details)


func _update_ship_details(ship_data: ShipData) -> void:
	$ShipDetailsContainer/ShipName.text = ship_data.name
	for i in range(crew_buttons.size()):
		crew_buttons[i].disabled = i >= ship_data.crew_slots.size()
	for i in range(weapon_buttons.size()):
		weapon_buttons[i].disabled = i >= ship_data.weapon_slots.size()
		if !weapon_buttons[i].disabled and ship_data.weapon_slots[i]:
			weapon_buttons[i].icon = ship_data.weapon_slots[i].ui_icon
		else:
			weapon_buttons[i].icon = null
