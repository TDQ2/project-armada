extends Node
class_name HealthComponent

#signal died
signal health_changed(percentHealthRemaining: float)

@export var max_health := 100.0
@export var current_health := 100.0

func take_damage(amount: float) -> void:
	current_health -= amount
	emit_signal("health_changed", current_health/max_health)
	if(current_health <=0):
		get_parent().call_deferred("queue_free")
