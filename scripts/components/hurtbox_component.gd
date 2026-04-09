extends Area2D
class_name HurtboxComponent

@export var healthComponent: HealthComponent

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " hurtbox should have a collision shape")
	assert(collision_mask == 0, str(get_parent()) + " hurtbox should not have collision masks")
	assert(collision_layer != 0, str(get_parent()) + " hurtbox should a have collision layer")
	assert(healthComponent, str(get_parent()) + " hurtbox requires a health component")

func take_damage(amount: float) -> void:
	healthComponent.take_damage(amount)
	
