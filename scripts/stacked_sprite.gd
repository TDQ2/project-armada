@tool
extends Sprite2D
class_name StackedSprite

# Used to tool to see in editor. show_sprites needs to be on render in game
@export var is_show_sprites: bool = false:
	set(value):
		is_show_sprites = value
		if value:
			render_sprites()
		else:
			clear_sprites()
@export var is_rotating_sprites: bool = false

#Used to determine sprite rotation
@export var direction_provider: Node

@export var curr_hframe := 0

func _ready() -> void:
	if is_show_sprites:
		render_sprites()

func _process(delta: float) -> void:
	global_rotation = 0.0
	if is_rotating_sprites:
		rotate_stack(delta)
	if direction_provider:
		var direction:Vector2 = direction_provider.direction
		set_stack_rotation(direction.angle())
	#change_frame(curr_hframe)

func render_sprites() -> void:
	clear_sprites()
	print("rendering")
	for i in range(vframes):
		var next_sprite := Sprite2D.new()
		next_sprite.texture = texture
		next_sprite.vframes = vframes
		next_sprite.hframes = hframes
		next_sprite.frame = i * hframes
		next_sprite.position.y = -i * 1
		add_child(next_sprite)

func clear_sprites() -> void:
	print("clearing")
	for sprite in get_children():
		sprite.queue_free()

func rotate_stack(amount: float) -> void:
	for child: Sprite2D in get_children():
		child.rotation += amount

func set_stack_rotation(rotation_: float) -> void:
	for child: Sprite2D in get_children():
		child.rotation = rotation_

# TO rename, this is animation
func change_frame(target_frame: int) -> void:
	print("change frame")
	for i: int in get_children().size():
		var child: Sprite2D = get_child(i)
		child.frame = i * hframes + target_frame
