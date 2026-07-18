extends Area2D
class_name HurtboxComponent

signal was_hit(on_hit: OnHitData)

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " hurtbox should have a collision shape")
	assert(collision_mask == 0, str(get_parent()) + " hurtbox should not have collision masks")
	assert(collision_layer != 0, str(get_parent()) + " hurtbox should a have collision layer")

func emit_was_hit(on_hit: OnHitData) -> void:
	was_hit.emit(on_hit)
