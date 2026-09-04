extends Node2D
class_name WeaponBase

signal fired(weapon_data: WeaponData)

var weapon_data: WeaponData

var target: Area2D
var can_shoot := true

@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var detection_area: CollisionShape2D = $DetectionComponent/CollisionShape2D
var on_hit_data: OnHitData

func _ready() -> void:
	detection_component.detection_area_entered.connect(_acquire_target)
	detection_component.detection_area_exited.connect(_release_target)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)

func _process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		if can_shoot:
			_shoot()

func _shoot() -> void:
	#print("shooting " + str(self))
	WorldEvents.emit_player_weapon_fired(
		weapon_data.player_projectile_type, 
		global_position, 
		(target.global_position - global_position).normalized(), 
		on_hit_data.duplicate())
	fired.emit(weapon_data)
	$ShootSound.play(0.25)
	can_shoot = false
	$CooldownTimer.start()

func _on_cooldown_timer_timeout() -> void:
	can_shoot = true

func set_weapon_data(weapon_data_: WeaponData) -> void:
	weapon_data = weapon_data_
	refresh()

func refresh() -> void:
	_update_range()
	_set_cooldown()
	_set_on_hit_component()

func _update_range() -> void:
	var range_modifiers = weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.RANGE
	)
	var all_in_range: float = Utils.compute_modified_stat(weapon_data.fire_range, range_modifiers)
	detection_area.shape.radius = all_in_range * Data.WEAPON_UNIT_RANGE

func _set_cooldown() -> void:
	var cooldown_modifiers = weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.COOLDOWN
	)
	var all_in_cooldown: float = Utils.compute_modified_stat(weapon_data.cooldown_duration, cooldown_modifiers)
	cooldown_timer.wait_time = all_in_cooldown

func _set_on_hit_component() -> void:
	#print("setting on hit. damage = " + str(weapon_data_.damage))
	var damage_modifiers = weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.DAMAGE
	)
	var all_in_damage: float = Utils.compute_modified_stat(weapon_data.damage, damage_modifiers)
	on_hit_data = OnHitData.new(all_in_damage, weapon_data.status_effects)

func _acquire_target(area: Area2D) -> void:
	target = area

func _release_target(_area: Area2D) -> void:
	target = null
