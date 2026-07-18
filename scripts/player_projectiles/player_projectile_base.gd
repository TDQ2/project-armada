extends Node2D
class_name PlayerProjectileBase

var direction: Vector2
@export var speed := 200

@onready var sprite: Sprite2D = $Sprite2D
@onready var hit_box_component: HitBoxComponent = $HitboxComponent

func _ready() -> void:
	assert(sprite.texture != null, str(self) + "sprite for projectile base is missing texture")

func setup(pos: Vector2, dir: Vector2, on_hit: OnHitData) -> void:
	#print("Projectile setup with damage = " + str(on_hit.damage))
	position = pos
	direction = dir
	rotation = direction.angle()
	hit_box_component.setup(on_hit)
	

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
