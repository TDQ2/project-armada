extends Area2D

var direction: Vector2
var speed := 200

var damage := 10.0

func setup(pos: Vector2, dir: Vector2) -> void:
	position = pos
	direction = dir
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
