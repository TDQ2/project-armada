extends PanelContainer

@onready var doneButton: Button = $VBoxContainer/DoneButton

func _ready() -> void:
	doneButton.pressed.connect(_handle_done_button_pressed)
	
func _handle_done_button_pressed() -> void:
	# TODO: this should long term be handled by a command which interacts with the run state
	get_tree().paused = false
	get_parent().hide()
