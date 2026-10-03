class_name MovementComponent
extends Node

#state management
enum MoveState {
	PATROL,
	PURSUE,
	RETURN,
	IDLE,
}


# Controls
@export var speed := 40
@export var slerp_speed := 3 # speed of slerp rotation
@export var idle_time := 1 # time spent in idle before transition
@export var dist_to_target := 8.0

#Dependencies
@export var detection_component: DetectionComponent
@export var waypoints_container: Node2D

var direction := Vector2.RIGHT

var _move_state: MoveState
var _pursue_target: Area2D # Only present when pursuing, otherwise null
var _waypoints: Array[Vector2] #Established on ready
var _patrol_idx := 0

@onready var this_ship: Node2D = get_parent()
@onready var return_position: Vector2 = this_ship.global_position


func _ready() -> void:
	assert(waypoints_container)
	assert(detection_component)
	for waypoint in waypoints_container.get_children() as Array[Marker2D]:
		_waypoints.append(waypoint.global_position)
	detection_component.detection_area_entered.connect(_being_pursue)
	detection_component.detection_area_exited.connect(_being_disengage)


func _physics_process(delta: float) -> void:
	match _move_state:
		MoveState.PATROL:
			_patrol(delta)
		MoveState.PURSUE:
			_pursue(delta)
		MoveState.RETURN:
			_return(delta)
		MoveState.IDLE:
			_idle(delta)
	get_parent().rotation = direction.angle()


# State functions
func _patrol(delta: float) -> void:
	assert(_waypoints.size() > 0)
	_steer_toward(_waypoints[_patrol_idx], delta)
	if this_ship.global_position.distance_to(_waypoints[_patrol_idx]) <= dist_to_target:
		_patrol_idx = (_patrol_idx + 1) % _waypoints.size()
		_start_idle()


func _pursue(delta: float) -> void:
	_steer_toward(_pursue_target.global_position, delta)


func _return(delta: float) -> void:
	_steer_toward(return_position, delta)
	if this_ship.global_position.distance_to(return_position) <= dist_to_target:
		_start_idle()


func _idle(_delta: float) -> void:
	# Do nothing, transition via IdleTimer
	pass


# State function helpers
func _steer_toward(global_pos: Vector2, delta: float) -> void:
	var target_dir := (global_pos - get_parent().global_position).normalized() as Vector2
	direction = direction.slerp(target_dir, slerp_speed * delta)
	get_parent().position += direction * speed * delta


func _start_idle() -> void:
	$IdleTimer.start(idle_time)
	_move_state = MoveState.IDLE


# State transitions
func _being_pursue(area: Area2D) -> void:
	_pursue_target = area
	_move_state = MoveState.PURSUE


func _being_disengage(_area: Area2D) -> void:
	_pursue_target = null
	_move_state = MoveState.RETURN


func _on_idle_timer_timeout() -> void:
	if _move_state == MoveState.IDLE:
		_move_state = MoveState.PATROL
