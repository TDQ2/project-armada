class_name ClickTarget
extends Node2D

signal position_targeted(pos: Vector2)

@onready var _click_animation := $ClickAnimation


func _ready() -> void:
	hide()
	_click_animation.animation_finished.connect(_handle_animation_finished)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_to"):
		global_position = get_global_mouse_position()
		show()
		_click_animation.stop()
		_click_animation.frame = 0
		_click_animation.play()
		position_targeted.emit(global_position)


func _handle_animation_finished() -> void:
	hide()
