extends Area2D

@export var movement_component: MovementComponent

func _on_area_entered(area: Area2D) -> void:
	print("detected player")
	movement_component.pursue(area)

func _on_area_exited(_area: Area2D) -> void:
	print("detection left")
	movement_component.disengage()
