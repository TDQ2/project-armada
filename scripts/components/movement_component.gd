extends Node
class_name MovementComponent

# Controls
@export var speed := 40
@export var slerp_speed := 3 # speed of slerp rotation
@export var idle_time := 1 # time spent in idle before transition
@export var dist_to_target := 8.0

#Dependencies
@export var detection_component: DetectionComponent
@export var waypoints_container: Node2D
@onready var this_ship: Node2D = get_parent()

#state management
enum State {PATROL, PURSUE, RETURN, IDLE}
var state: State

#direction and targets
var direction := Vector2.RIGHT
var pursue_target: Area2D # Only present when pursuing, otherwise null
@onready var return_position: Vector2 = this_ship.global_position
var waypoints: Array[Vector2] #Established on ready
var patrol_idx := 0

func _ready() -> void:
	assert(waypoints_container)
	assert(detection_component)
	for waypoint in waypoints_container.get_children() as Array[Marker2D]:
		waypoints.append(waypoint.global_position)
	detection_component.detection_area_entered.connect(_being_pursue)
	detection_component.detection_area_exited.connect(_being_disengage)

func _physics_process(delta: float) -> void:
	match state:
		State.PATROL: _patrol(delta)
		State.PURSUE: _pursue(delta)
		State.RETURN: _return(delta)
		State.IDLE: _idle(delta)
	get_parent().rotation = direction.angle()

# State functions
func _patrol(delta: float) -> void:
	assert(waypoints.size() > 0)
	_steer_toward(waypoints[patrol_idx], delta)
	if this_ship.global_position.distance_to(waypoints[patrol_idx]) <= dist_to_target:
		patrol_idx = (patrol_idx + 1) % waypoints.size()
		_start_idle()

func _pursue(delta: float) -> void:
	_steer_toward(pursue_target.global_position, delta)

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
	state = State.IDLE

# State transitions
func _being_pursue(area: Area2D) -> void:
	pursue_target = area
	state = State.PURSUE

func _being_disengage(_area: Area2D) -> void:
	pursue_target = null
	state = State.RETURN

func _on_idle_timer_timeout() -> void:
	if state == State.IDLE:
		state = State.PATROL
