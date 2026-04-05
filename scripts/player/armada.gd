extends Node2D

@export var speed := 50
@export var rotation_speed := 0.01 # radians per second

var direction := Vector2.UP

func _physics_process(delta: float) -> void:
	_handle_movement(delta)

func _handle_movement(delta: float) -> void:
	if Input.is_action_pressed("left"):
		direction = direction.rotated(-rotation_speed)
	elif Input.is_action_pressed("right"):
		direction = direction.rotated(rotation_speed)
	var velocity := direction * speed
	position += velocity * delta
	rotation = velocity.angle() + PI / 2
