extends Node2D

@export var _speed := 200
var _direction: Vector2

func setup(pos: Vector2, dir: Vector2, damage: float) -> void:
	position = pos
	_direction = dir
	$DamageComponent.amount = damage
	rotation = _direction.angle()


func _physics_process(delta: float) -> void:
	position += _direction * _speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
