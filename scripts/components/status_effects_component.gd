class_name StatusEffectsComponent
extends Node2D

var _host: EnemyBase
var _visual_offset: Vector2

@onready var statuses_container: HBoxContainer = $StatusesContainer


func _ready() -> void:
	_visual_offset = position


func setup(host_) -> void:
	_host = host_


func _physics_process(_delta: float) -> void:
	global_rotation = 0
	global_position = get_parent().global_position + _visual_offset


func apply_status_effects(status_effects: Array[StatusEffectData]) -> void:
	for status_effect: StatusEffectData in status_effects:
		var existing_status_effect_opt := statuses_container.get_children().filter(
			func(se: StatusEffectBase):
				return se.status_effect_type == status_effect.type,
		)
		if existing_status_effect_opt.is_empty():
			# TODO: status effects should take data and create instead of by type
			var status_effect_scene = Data.world_status_effects[status_effect.type]
			var status_effect_base: StatusEffectBase = status_effect_scene.instantiate()
			statuses_container.add_child(status_effect_base)
			status_effect_base.setup(_host)
		else:
			assert(
				existing_status_effect_opt.size() == 1,
				"Status effect has been applied more than once. type=" + str(status_effect.type),
			)
			var existing_status_effect: StatusEffectBase = existing_status_effect_opt[0]
			existing_status_effect.reapply()
