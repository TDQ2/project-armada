extends Area2D
class_name HitBoxComponent

@export var free_on_hit := false # TODO: may need to refactor to signal later

var on_hit_component: OnHitComponent

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " hitbox should have collision mask")
	assert(collision_mask != 0, str(get_parent()) + " hitbox should have collision mask")
	assert(collision_layer == 0, str(get_parent()) + " hitbox should not have collision layers")

func setup(on_hit: OnHitComponent) -> void:
	on_hit_component = on_hit

func _on_area_entered(area: Area2D) -> void:
	assert(area is HurtboxComponent, "Hitbox collided with non-hurtbox" + area.name)
	assert(on_hit_component != null, "On hit component was not assigned to hitbox component, check projectile setup")
	var hurtbox := area as HurtboxComponent
	hurtbox.emit_was_hit(on_hit_component)
	if free_on_hit:
		get_parent().queue_free()
