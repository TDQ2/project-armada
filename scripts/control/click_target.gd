extends Node2D
class_name ClickTarget

@onready var clickAnimation := $ClickAnimation

signal position_targeted(pos: Vector2)

func _ready() -> void:
	hide()
	clickAnimation.animation_finished.connect(_handle_animation_finished)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_to"):
		global_position = get_global_mouse_position()
		show()
		clickAnimation.stop()
		clickAnimation.frame = 0
		clickAnimation.play()
		position_targeted.emit(global_position)

func _handle_animation_finished() -> void:
	hide()
