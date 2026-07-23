extends PoiBase

@onready var unclearedSprite: Sprite2D = $UnclearedSprite

func _ready() -> void:
	super()
	var uncleared_sprite_tween = create_tween()
	uncleared_sprite_tween.set_loops()
	uncleared_sprite_tween.tween_property(unclearedSprite, "frame", 2, 1.0)
	uncleared_sprite_tween.tween_property(unclearedSprite, "frame", 0, 1.0)
	
