extends Node2D
class_name ShipBase

var ship_data: ShipData
@onready var weapons_component: WeaponsComponent = $WeaponsComponent
@onready var actor_animation_component: ActorAnimationComponent = $ActorAnimationComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent

func _ready() -> void:
	hurtbox.was_hit.connect(_handle_was_hit)

func setup(direction_provider: Node2D) -> void:
	actor_animation_component.direction_provider = direction_provider

func sync() -> void:
	weapons_component.sync(ship_data.weapon_slots)

func _handle_was_hit(on_hit: OnHitComponent) -> void:
	#print("enemy was hit for damage = " + str(on_hit.damage))
	health_component.take_damage(on_hit.damage)
