extends Node2D
class_name EnemyBase

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var status_effects_component: StatusEffectsComponent = $StatusEffectsComponent

func _ready() -> void:
	hurtbox.was_hit.connect(_handle_was_hit)
	status_effects_component.setup(self)

func _handle_was_hit(on_hit: OnHitData) -> void:
	#print("enemy was hit for damage = " + str(on_hit.damage))
	health_component.take_damage(on_hit.damage)
	status_effects_component.apply_status_effects(on_hit.status_effects)
