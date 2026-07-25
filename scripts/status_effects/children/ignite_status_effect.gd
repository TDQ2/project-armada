extends StatusEffectBase

@export var tick_duration: float
@export var percent_health_damage: int

@onready var tick_timer: Timer = $TickTimer

func _ready() -> void:
	super._ready()
	tick_timer.wait_time = tick_duration
	tick_timer.start()
	tick_timer.timeout.connect(_handle_tick_timer_timeout)

func _handle_tick_timer_timeout() -> void:
	_deal_tick_damage()

func _deal_tick_damage() -> void:
	var max_health = host.health_component.max_health
	var damage = (percent_health_damage / 100.0) * max_health
	host.health_component.take_damage(damage)
