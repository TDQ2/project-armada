class_name EnemyWeaponBase
extends Node2D

@export var projectile_type: Data.EnemyProjectileType

var _target: Area2D
var _can_shoot := true

@onready var detection_component: DetectionComponent = $DetectionComponent
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var detection_area: CollisionShape2D = $DetectionComponent/CollisionShape2D
@onready var on_hit_component: OnHitComponent = $OnHitComponent


func _ready() -> void:
	assert(projectile_type != Data.EnemyProjectileType.UNDEFINED, "enemy weapon is undefined")
	assert(projectile_type != null, "enemy weapon is missing projectile type")
	detection_component.detection_area_entered.connect(_acquire_target)
	detection_component.detection_area_exited.connect(_release_target)
	cooldown_timer.timeout.connect(_on_cooldown_timer_timeout)


func _process(_delta: float) -> void:
	if _target:
		look_at(_target.global_position)
		if _can_shoot:
			_shoot()


func _shoot() -> void:
	WorldEvents.emit_enemy_weapon_fired(
		projectile_type,
		global_position,
		(_target.global_position - global_position).normalized(),
		on_hit_component.on_hit_data.duplicate()
	)
	$ShootSound.play(0.25)
	_can_shoot = false
	$CooldownTimer.start()


func _on_cooldown_timer_timeout() -> void:
	_can_shoot = true


func _acquire_target(area: Area2D) -> void:
	_target = area


func _release_target(_area: Area2D) -> void:
	_target = null
