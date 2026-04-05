extends Area2D

@export var healthComponent: HealthComponent

func _ready() -> void:
	assert(healthComponent)
	assert($CollisionShape2D.shape)

func _on_area_entered(area: Area2D) -> void:
	var damage = area.get_parent().get_node_or_null("DamageComponent") as DamageComponent
	if damage:
		healthComponent.take_damage(damage.amount)
	
