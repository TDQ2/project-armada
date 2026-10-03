class_name WeaponBase
extends Node2D


signal fired(weapon_data: WeaponData)

var _weapon_data: WeaponData

var _target: Area2D
var _can_shoot := true
var _on_hit_data: OnHitData


@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var detection_area: CollisionShape2D = $DetectionComponent/CollisionShape2D



func _ready() -> void:
	detection_component.detection_area_entered.connect(_acquire_target)
	detection_component.detection_area_exited.connect(_release_target)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)


func _process(_delta: float) -> void:
	if _target:
		look_at(_target.global_position)
		if _can_shoot:
			_shoot()


func _shoot() -> void:
	#print("shooting " + str(self))
	WorldEvents.emit_player_weapon_fired(
		_weapon_data.player_projectile_type,
		global_position,
		(_target.global_position - global_position).normalized(),
		_on_hit_data.duplicate()
	)
	fired.emit(_weapon_data)
	$ShootSound.play(0.25)
	_can_shoot = false
	$CooldownTimer.start()


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func set_weapon_data(weapon_data_: WeaponData) -> void:
	_weapon_data = weapon_data_
	refresh()


func refresh() -> void:
	_update_range()
	_set_cooldown()
	_set_on_hit_component()


func _update_range() -> void:
	var range_modifiers = _weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.RANGE
	)
	var all_in_range: float = Utils.compute_modified_stat(_weapon_data.fire_range, range_modifiers)
	detection_area.shape.radius = all_in_range * Data.WEAPON_UNIT_RANGE


func _set_cooldown() -> void:
	var cooldown_modifiers = _weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.COOLDOWN
	)
	var all_in_cooldown: float = Utils.compute_modified_stat(
		_weapon_data.cooldown_duration, cooldown_modifiers
	)
	cooldown_timer.wait_time = all_in_cooldown


func _set_on_hit_component() -> void:
	#print("setting on hit. damage = " + str(weapon_data_.damage))
	var damage_modifiers = _weapon_data.granted_modifiers.filter(
		func(modifier: StatModifier): return modifier.attribute == Data.StatAttribute.DAMAGE
	)
	var all_in_damage: float = Utils.compute_modified_stat(_weapon_data.damage, damage_modifiers)
	_on_hit_data = OnHitData.new(all_in_damage, _weapon_data.status_effects)


func _acquire_target(area: Area2D) -> void:
	_target = area


func _release_target(_area: Area2D) -> void:
	_target = null
