extends Node
class_name HealthComponent

#signal died
#signal health_changed(amount: float)

@export var max_health := 100.0
@export var current_health := 100.0

func take_damage(amount: float) -> void:
	#print(str(self) + "took damage")
	current_health -= amount
