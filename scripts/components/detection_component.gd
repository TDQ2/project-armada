extends Area2D
class_name DetectionComponent

signal detection_area_entered(area: Area2D)
signal detection_area_exited(area: Area2D)

func _ready() -> void:
	assert(Utils.has_collision_shape(self), str(get_parent()) + " detection should have collision mask")
	assert(collision_mask != 0, str(get_parent()) + " detection should have collision mask")
	assert(collision_layer == 0, str(get_parent()) + " detection should not have collision layers")
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)

func _on_area_entered(area: Area2D) -> void:
	emit_signal("detection_area_entered", area)

func _on_area_exited(area: Area2D) -> void:
	emit_signal("detection_area_exited", area)
