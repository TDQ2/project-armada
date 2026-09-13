extends Node2D
class_name StatusEffectsComponent

var host: EnemyBase
@onready var statuses_container: HBoxContainer = $StatusesContainer

var visual_offset:Vector2

func _ready() -> void:
	visual_offset = position

func setup(host_) -> void:
	host = host_

func _physics_process(_delta: float) -> void:
	global_rotation = 0
	global_position = get_parent().global_position + visual_offset

func apply_status_effects(status_effects: Array[Data.StatusEffectType]) -> void:
	for status_effect_type_ in status_effects:
		var existing_status_effect_opt := statuses_container.get_children().filter(func(se: StatusEffectBase): return se.status_effect_type == status_effect_type_)
		if existing_status_effect_opt.is_empty():
			#print("apply status_effect " + str(status_effect_type_))
			var status_effect_scene = Data.world_status_effects[status_effect_type_]
			var status_effect: StatusEffectBase = status_effect_scene.instantiate()
			statuses_container.add_child(status_effect)
			status_effect.setup(host)
		else:
			assert(existing_status_effect_opt.size() == 1, "Status effect has been applied more than once. type=" + str(status_effect_type_))
			var existing_status_effect: StatusEffectBase = existing_status_effect_opt[0]
			existing_status_effect.reapply()
