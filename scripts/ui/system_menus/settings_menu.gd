extends PanelContainer
class_name SettingsMenu

@export var master_bus_name: String
@export var music_bus_name: String
@export var sound_effects_bus_name: String

var master_bus_index: int
var music_bus_index: int
var sound_effects_bus_index: int

@onready var buttons_container := $VBoxContainer/ButtonsContainer
@onready var master_volume_slider: HSlider = $VBoxContainer/AudioControlsContainer/GridContainer/MasterVolumeSlider
@onready var music_volume_slider:  HSlider = $VBoxContainer/AudioControlsContainer/GridContainer/MusicVolumeSlider
@onready var sound_effects_volume_slider: HSlider = $VBoxContainer/AudioControlsContainer/GridContainer/SoundEffectsVolumeSlider

@onready var gameplay_ui: GameplayUI

func _ready() -> void:
	master_bus_index = AudioServer.get_bus_index("Master")
	music_bus_index = AudioServer.get_bus_index("Music")
	sound_effects_bus_index = AudioServer.get_bus_index("Sound Effects")
	master_volume_slider.value = State.config.master_bus_value
	music_volume_slider.value = State.config.music_bus_value
	sound_effects_volume_slider.value = State.config.sound_effects_bus_value
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(State.config.master_bus_value))
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(State.config.music_bus_value))
	AudioServer.set_bus_volume_db(sound_effects_bus_index, linear_to_db(State.config.sound_effects_bus_value))
	gameplay_ui = get_node_or_null("../GameplayUI")
	
	if get_parent() is MainMenu:
		buttons_container.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("settings"):
		toggle_settings_ui()

func toggle_settings_ui() -> void:
	if not visible:
		show()
		get_tree().paused = true
	else:
		hide()
		if gameplay_ui != null and !gameplay_ui.visible:
			get_tree().paused = false

func _on_master_volume_slider_value_changed(value: float) -> void:
	if value:
		State.config.master_bus_value = value
		AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(State.config.master_bus_value))

func _on_music_volume_slider_value_changed(value: float) -> void:
	if value:
		State.config.music_bus_value = value
		AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(State.config.music_bus_value))

func _on_sound_effects_volume_slider_value_changed(value: float) -> void:
	if value:
		State.config.sound_effects_bus_value = value
		AudioServer.set_bus_volume_db(sound_effects_bus_index, linear_to_db(State.config.sound_effects_bus_value))

func _on_quit_pressed() -> void:
	print("clicked quit")
	get_tree().quit()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/ui/system_menus/main_menu.tscn")
