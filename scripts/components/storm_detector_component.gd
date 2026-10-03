extends Area2D
class_name  StormDetectorComponent

# Because tilemap must be a collision layer, creating a component which is like a
# hurtbox but only detects the storm since this is arguably a hurtbox

signal storm_entered
signal storm_exited

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " storm detector should have a collision shape")

func _on_area_entered(_area: Area2D) -> void:
	storm_entered.emit()

func _on_area_exited(_area: Area2D) -> void:
	storm_exited.emit()
