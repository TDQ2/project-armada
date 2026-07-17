extends PanelContainer
class_name TopNavPanel

signal map_button_pressed
signal fleet_button_pressed

@onready var map_button: Button = $ButtonsContainer/MapButton
@onready var fleet_button: Button = $ButtonsContainer/FleetButton

func _ready() -> void:
	map_button.pressed.connect(_emit_map_button_pressed)
	fleet_button.pressed.connect(_emit_fleet_button_pressed)

func _emit_map_button_pressed() -> void:
	print("map button pressed")
	map_button_pressed.emit()

func _emit_fleet_button_pressed() -> void:
	print("fleet button pressed")
	fleet_button_pressed.emit()
