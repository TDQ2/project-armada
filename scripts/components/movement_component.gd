extends Node
class_name MovementComponent

# Controls
@export var speed := 40
@export var slerp_speed := 3 # speed of slerp rotation
@export var idle_time := 1 # time spent in idle before transition
@export var dist_to_target := 8.0

#Dependencies
@export var waypoints_container: Node2D
@onready var this_ship: Node2D = get_parent()

#state management
enum State {PATROL, CHASE, RETURN, IDLE}
var state: State

#direction and targets
var direction := Vector2.RIGHT
var chase_target: Area2D # Only present when chasing, otherwise null
@onready var return_position: Vector2 = this_ship.global_position
var waypoints: Array[Vector2] #Established on ready
var patrol_idx := 0

func _ready() -> void:
	assert(waypoints_container)
	for waypoint in waypoints_container.get_children() as Array[Marker2D]:
		waypoints.append(waypoint.global_position)

func _physics_process(delta: float) -> void:
	match state:
		State.PATROL: _patrol(delta)
		State.CHASE: _chase(delta)
		State.RETURN: _return(delta)
		State.IDLE: _idle(delta)
		
func _patrol(delta: float) -> void:
	assert(waypoints.size() > 0)
	_steer_toward(waypoints[patrol_idx], delta)
	if this_ship.global_position.distance_to(waypoints[patrol_idx]) <= dist_to_target:
		print("reached waypoint ", patrol_idx, " switching to idle")
		patrol_idx = (patrol_idx + 1) % waypoints.size()
		_start_idle()
		

func _chase(delta: float) -> void:
	_steer_toward(chase_target.global_position, delta)

func _return(delta: float) -> void:
	_steer_toward(return_position, delta)
	if this_ship.global_position.distance_to(return_position) <= dist_to_target:
		_start_idle()

func _idle(_delta: float) -> void:
	# Do nothing, transition via IdleTimer
	pass

func _steer_toward(global_pos: Vector2, delta: float) -> void:
	var target_dir := (global_pos - get_parent().global_position).normalized() as Vector2
	direction = direction.slerp(target_dir, slerp_speed * delta)
	get_parent().position += direction * speed * delta

func _start_idle() -> void:
	$IdleTimer.start(idle_time)
	state = State.IDLE

func pursue(area: Area2D) -> void:
	chase_target = area
	state = State.CHASE

func disengage() -> void:
	chase_target = null
	state = State.RETURN

func _on_idle_timer_timeout() -> void:
	if state == State.IDLE:
		state = State.PATROL
