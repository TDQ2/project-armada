extends Node2D
class_name PlayerProjectileBase

var direction: Vector2
@export var speed := 200

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	assert(sprite.texture != null, str(self) + "sprite for projectile base is missing texture")

func setup(pos: Vector2, dir: Vector2, damage: float) -> void:
	position = pos
	direction = dir
	$DamageComponent.amount = damage
	rotation = direction.angle()

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
