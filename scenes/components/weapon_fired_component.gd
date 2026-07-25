extends Node2D
class_name WeaponFiredComponent

var visual_offset:Vector2

const FLASH_DURATION := 1.0

@onready var flashContainer := $FlashContainer

func _ready() -> void:
	visual_offset = position

func _physics_process(_delta: float) -> void:
	global_rotation = 0
	global_position = get_parent().global_position + visual_offset

func flash_weapon(weapon_data: WeaponData) -> void:
	# create
	var flash_texture_rect := TextureRect.new()
	flashContainer.add_child(flash_texture_rect)
	flash_texture_rect.texture = weapon_data.ui_icon
	
	# tween modulate
	var flash_tween := create_tween()
	flash_tween.tween_property(flash_texture_rect,"modulate:a",0, min(FLASH_DURATION, weapon_data.cooldown_duration))
	await flash_tween.finished
	if is_instance_valid(flash_texture_rect): 
		flash_texture_rect.queue_free()
