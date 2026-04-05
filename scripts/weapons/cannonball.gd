extends Node2D

var direction: Vector2
@export var speed := 200
var hit_layer: int
var hit_mask: int

func setup(pos: Vector2, dir: Vector2, layer: int, mask: int) -> void:
	position = pos
	direction = dir
	rotation = direction.angle()
	hit_layer = layer
	hit_mask = mask

func _ready() -> void:
	$HitboxComponent.set_collision_layer_value(hit_layer, true)
	$HitboxComponent.set_collision_layer_value(hit_mask, true)

func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	call_deferred("queue_free")
