extends Area2D

@export var healthComponent: HealthComponent

func _on_area_entered(_area: Area2D) -> void:
	assert(healthComponent)
	#print("enemy hit")
	healthComponent.take_damage(1) #TODO: make this the damaage of the cannonball
	
