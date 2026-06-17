extends Node2D
class_name WeaponBase

var weapon_data: WeaponData

var target: Area2D
var can_shoot := true

@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var detection_area: CollisionShape2D = $DetectionComponent/CollisionShape2D

func _ready() -> void:
	detection_component.detection_area_entered.connect(_acquire_target)
	detection_component.detection_area_exited.connect(_release_target)

func _process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		if can_shoot:
			_shoot()

func _shoot() -> void:
	print("shooting")
	WorldEvents.emit_player_weapon_fired(global_position, (target.global_position - global_position).normalized(), weapon_data.damage)
	$ShootSound.play(0.25)
	can_shoot = false
	$CooldownTimer.start()

func set_weapon_data(weapon_data_: WeaponData) -> void:
	weapon_data = weapon_data_
	_update_range(weapon_data.fire_range * Data.WEAPON_UNIT_RANGE)
	_set_cooldown(weapon_data.cooldown_duration)

func _update_range(range_: int) -> void:
	detection_area.shape.radius = range_

func _set_cooldown(duration_: float) -> void:
	cooldown_timer.wait_time = duration_

func _acquire_target(area: Area2D) -> void:
	target = area

func _release_target(_area: Area2D) -> void:
	target = null
