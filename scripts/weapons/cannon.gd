extends Node2D


signal shoot(pos: Vector2, direction: Vector2)

@export var cannon_range := 4

var target: Area2D
var can_shoot := true

func _ready() -> void:
	$DetectionRange/CollisionShape2D.shape.radius = cannon_range * 16

func _process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		if can_shoot:
			_shoot()

func _on_detection_range_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		target = area

func _on_detection_range_area_exited(_area: Area2D) -> void:
	target = null

func _shoot() -> void:
	emit_signal("shoot", global_position, (target.global_position - global_position).normalized())
	$ShootSound.play(0.25)
	can_shoot = false
	$CooldownTimer.start()

func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
