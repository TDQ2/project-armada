class_name ShipBase
extends Node2D

const STORM_TICK_DAMAGE := 2

var ship_data: ShipData
var target_dest: Vector2

@onready var weapons_component: WeaponsComponent = $WeaponsComponent
@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox: HurtboxComponent = $HurtboxComponent
@onready var weapon_fired_component: WeaponFiredComponent = $WeaponFiredComponent
@onready var stacked_sprite: StackedSprite = $StackedSprite
@onready var storm_detector_component: StormDetectorComponent = $StormDetectorComponent
@onready var storm_tick_timer: Timer = $StormTickTimer


# TODO: consider different types of rotation for each ship to improve look
#var current_heading: float = Vector2.UP.angle()
#var target_angle := Vector2.UP.angle()

#const ANGLE_LERP := 1.0


func _ready() -> void:
	hurtbox.was_hit.connect(_handle_was_hit)
	weapons_component.weapon_fired.connect(_handle_weapon_fired)
	storm_detector_component.storm_entered.connect(_handle_storm_entered)
	storm_detector_component.storm_exited.connect(_handle_storm_exited)
	storm_tick_timer.timeout.connect(_on_storm_tick_timer_timeout)

	#stacked_sprite.set_stack_rotation(-PI/2)


#func _process(delta: float) -> void:
#if target_dest:
#target_angle = global_position.angle_to_point(target_dest)
#current_heading = lerp_angle(current_heading, target_angle, ANGLE_LERP*delta)
#stacked_sprite.set_stack_rotation(current_heading)


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


func set_target_dest(dest: Vector2) -> void:
	target_dest = dest


func _handle_storm_entered() -> void:
	storm_tick_timer.start()


func _handle_storm_exited() -> void:
	storm_tick_timer.stop()


func _on_storm_tick_timer_timeout() -> void:
	health_component.take_damage(STORM_TICK_DAMAGE)
