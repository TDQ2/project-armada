class_name HealthBarComponent
extends Node2D

@export var health_component: HealthComponent
@export var show_duration := 1.0

var visual_offset: Vector2


func _ready() -> void:
	visible = false
	assert(health_component)
	health_component.health_changed.connect(_show_health)
	visual_offset = position


func _physics_process(_delta: float) -> void:
	global_rotation = 0
	global_position = get_parent().global_position + visual_offset


func _show_health(percent_health_remaining: float) -> void:
	$ProgressBar.value = percent_health_remaining
	visible = true
	$VisibleTimer.start(show_duration)


func _on_visible_timer_timeout() -> void:
	visible = false
