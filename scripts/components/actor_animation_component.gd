extends Node2D
class_name ActorAnimationComponent

@export var direction_provider: Node

@onready var animation_tree := $AnimationTree
@onready var sprite: Sprite2D = $Sprite2D

func _process(_delta: float) -> void:
	assert(sprite.texture != null, str(self) + " sprite is missing a texture")
	global_rotation = 0.0
	animation()

func animation() -> void:
	var direction := direction_provider.direction as Vector2
	var rounded_direction = Vector2(round(direction.x), round(direction.y))
	animation_tree.set("parameters/MoveStateMachine/Move/blend_position", rounded_direction)
