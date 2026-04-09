extends Node2D

var direction: Vector2
@export var speed := 200

func setup(pos: Vector2, dir: Vector2) -> void:
	position = pos
	direction = dir
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
