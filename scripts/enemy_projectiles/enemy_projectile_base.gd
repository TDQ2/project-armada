class_name EnemyProjectileBase
extends Node2D



@export var speed := 200

var _direction: Vector2

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box_component: HitBoxComponent = $HitboxComponent


func _ready() -> void:
	assert(sprite.texture != null, str(self) + "sprite for projectile base is missing texture")


func setup(pos: Vector2, dir: Vector2, on_hit: OnHitData) -> void:
	#print("Projectile setup with damage = " + str(on_hit.damage))
	position = pos
	_direction = dir
	rotation = _direction.angle()
	hit_box_component.setup(on_hit)


func _physics_process(delta: float) -> void:
	position += _direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
