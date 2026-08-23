extends Node2D
class_name ShipBase

var ship_data: ShipData
@onready var weapons_component: WeaponsComponent = $WeaponsComponent
#@onready var actor_animation_component: ActorAnimationComponent = $ActorAnimationComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var weapon_fired_component: WeaponFiredComponent = $WeaponFiredComponent
@onready var stacked_sprite: StackedSprite = $StackedSprite

func _ready() -> void:
	hurtbox.was_hit.connect(_handle_was_hit)
	weapons_component.weapon_fired.connect(_handle_weapon_fired)

func setup(direction_provider: Node2D) -> void:
	#actor_animation_component.direction_provider = direction_provider
	stacked_sprite.direction_provider = direction_provider
	

func sync() -> void:
	weapons_component.sync(ship_data.weapon_slots)

func _handle_was_hit(on_hit: OnHitData) -> void:
	#print("enemy was hit for damage = " + str(on_hit.damage))
	health_component.take_damage(on_hit.damage)

func _handle_weapon_fired(weapon_data: WeaponData) -> void:
	weapon_fired_component.flash_weapon(weapon_data)
