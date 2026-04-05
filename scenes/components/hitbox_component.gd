extends Area2D

@export var free_on_hit := false # TODO: may need to refactor to signal later

func _ready() -> void:
	assert($CollisionShape2D.shape)

func _on_area_entered(_area: Area2D) -> void:
	print("collision_layer" + str(collision_layer))
	print("collision_mask" + str(collision_mask))
	print("cannonball hit" + str(_area) + " " + str(_area.get_parent()))
	if free_on_hit:
		get_parent().queue_free()
