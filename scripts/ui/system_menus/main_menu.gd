extends Control
class_name MainMenu

@onready var settingsMenu: SettingsMenu = $SettingsMenu

func _ready() -> void:
	get_tree().paused = false

func _on_new_game_pressed() -> void:
	# show loading screen
	# create state
	# create new world
	# change scene
	get_tree().change_scene_to_file("res://scenes/world/world.tscn")


func _on_settings_pressed() -> void:
	settingsMenu.toggle_settings_ui()

func _on_quit_pressed() -> void:
	get_tree().quit()
