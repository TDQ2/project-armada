extends Node2D

signal shoot(source: Data.ProjectileSource, pos: Vector2, direction: Vector2, damage)

@export var cannon_range := 4
@export var source: Data.ProjectileSource = Data.ProjectileSource.UNDEFINED #Must be set in the editor
@export var damage := 20.0

@onready var detection_component: DetectionComponent = $DetectionComponent

var target: Area2D
var can_shoot := true

func _ready() -> void:
	assert(source != Data.ProjectileSource.UNDEFINED, str(get_parent()) + " cannon is missing projectile source")
	detection_component.detection_area_entered.connect(_acquire_target)
	detection_component.detection_area_exited.connect(_release_target)
	var detection_shape := CircleShape2D.new()
	detection_shape.radius = cannon_range * 16
	$DetectionComponent/CollisionShape2D.shape = detection_shape

func _process(_delta: float) -> void:
	if target:
		look_at(target.global_position)
		if can_shoot:
			_shoot()

func _acquire_target(area: Area2D) -> void:
	target = area

func _release_target(_area: Area2D) -> void:
	target = null

func _shoot() -> void:
	#print("shooting")
	#_shoot_sw(source, global_position, (target.global_position - global_position).normalized(), damage)
	$ShootSound.play(0.25)
	can_shoot = false
	$CooldownTimer.start()

#shoot signal wrapper for type satefy
func _shoot_sw(source_: Data.ProjectileSource, pos: Vector2, direction: Vector2, damage_) -> void: 
	emit_signal("shoot", source_, pos, direction, damage_)

func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
