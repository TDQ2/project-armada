extends Area2D

@export var free_on_hit := false # TODO: may need to refactor to signal later
@export var damage_component: DamageComponent

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " hitbox should have collision mask")
	assert(collision_mask != 0, str(get_parent()) + " hitbox should have collision mask")
	assert(collision_layer == 0, str(get_parent()) + " hitbox should not have collision layers")
	assert(damage_component, str(get_parent()) + " hitbox requires a damage component")

func _on_area_entered(area: Area2D) -> void:
	assert(area is HurtboxComponent, "Hitbox collided with non-hurtbox" + area.name)
	var hurtbox := area as HurtboxComponent
	hurtbox.take_damage(damage_component.amount)
	if free_on_hit:
		get_parent().queue_free()
