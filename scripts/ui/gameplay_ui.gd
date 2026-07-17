extends PanelContainer

@onready var fleet_manager_ui: PanelContainer = $VBoxContainer/FleetManagerUI
@onready var map_ui: PanelContainer = $VBoxContainer/MapUI
@onready var top_nav_panel: TopNavPanel = $VBoxContainer/TopNavPanel

func _ready() -> void:
	top_nav_panel.fleet_button_pressed.connect(_show_fleet_manager)
	top_nav_panel.map_button_pressed.connect(_show_map)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		_toggle_gameplay_ui()
	if event.is_action_pressed("map"):
		if visible and map_ui.visible:
			_toggle_gameplay_ui()
		elif visible and not map_ui.visible:
			_show_map()
		else:
			_show_map()
			_toggle_gameplay_ui()
	if event.is_action_pressed("fleet"):
		if visible and fleet_manager_ui.visible:
			_toggle_gameplay_ui()
		elif visible and not fleet_manager_ui.visible:
			_show_fleet_manager()
		else:
			_show_fleet_manager()
			_toggle_gameplay_ui()


func _toggle_gameplay_ui() -> void:
	if not visible:
		#TODO: there is probably a better place to put this check
		if !State.run_state.selected_cz_coords:
			Commands.select_flagship()
		show()
		get_tree().paused = true
	else:
		hide()
		get_tree().paused = false

func _show_map() -> void:
	map_ui.show()
	fleet_manager_ui.hide()

func _show_fleet_manager() -> void:
	fleet_manager_ui.show()
	map_ui.hide()
