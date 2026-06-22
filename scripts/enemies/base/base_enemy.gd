extends Node2D
class_name EnemyBase

@onready var sprite: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var status_effects_container: Node2D = $StatusEffects # Array of StatusEffectBase

func _ready() -> void:
	assert(sprite.texture != null, str(self) + " sprite is missing a texture")
	hurtbox.was_hit.connect(_handle_was_hit)

func _handle_was_hit(on_hit: OnHitComponent) -> void:
	#print("enemy was hit for damage = " + str(on_hit.damage))
	health_component.take_damage(on_hit.damage)
	_apply_status_effects(on_hit.status_effects)

func _apply_status_effects(status_effects: Array[Data.StatusEffectType]) -> void:
	for status_effect_type_ in status_effects:
		var existing_status_effect_container := status_effects_container.get_children().filter(func(se: StatusEffectBase): return se.status_effect_type == status_effect_type_)
		if existing_status_effect_container.is_empty():
			#print("apply status_effect " + str(status_effect_type_))
			var status_effect_scene = Data.world_status_effects[status_effect_type_]
			var status_effect: StatusEffectBase = status_effect_scene.instantiate()
			status_effects_container.add_child(status_effect)
			status_effect.setup(self)
		else:
			assert(existing_status_effect_container.size() == 1, "Status effect has been applied more than once. type=" + str(status_effect_type_))
			var existing_status_effect: StatusEffectBase = existing_status_effect_container[0]
			existing_status_effect.reapply()
