class_name StatusEffectBase
extends TextureRect

#Set in editor
@export var expiration_time: float

# data
var status_effect_type: Data.StatusEffectType

# Dependencies
var _host: EnemyBase

# child references
@onready var expiration_timer: Timer = $ExpirationTimer


func _ready() -> void:
	assert(
		expiration_time != 0 and expiration_time != null,
		"status effect does not have a expiration time",
	)
	expiration_timer.wait_time = expiration_time
	expiration_timer.timeout.connect(_handle_expiration_timer_timeout)
	expiration_timer.start(expiration_time)


func setup(host_: EnemyBase) -> void:
	_host = host_


func _handle_expiration_timer_timeout() -> void:
	#print("clearing status effect " + str(self))
	call_deferred("queue_free")


func reapply() -> void:
	#print("reapplying status effect")
	expiration_timer.start(expiration_time)
