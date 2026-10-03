extends PoiBase

@onready var uncleared_sprite: Sprite2D = $UnclearedSprite
@onready var done_button: Button = $PoiUi/TreasureUI/VBoxContainer/DoneButton
@onready var reward_texture_rect: TextureRect = $PoiUi/TreasureUI/VBoxContainer/RewardBoxContainer2/RewardTextureRect


func _ready() -> void:
	super()
	done_button.pressed.connect(_handle_done_button_pressed)
	var uncleared_sprite_tween = create_tween()
	uncleared_sprite_tween.set_loops()
	uncleared_sprite_tween.tween_property(uncleared_sprite, "frame", 2, 1.0)
	uncleared_sprite_tween.tween_property(uncleared_sprite, "frame", 0, 1.0)


func setup(poi_data_: PoiData): #overwrites parents
	_poi_data = poi_data_
	position = _poi_data.position
	assert(_poi_data.weapons.size() == 1)
	reward_texture_rect.texture = _poi_data.weapons[0].ui_icon


func _handle_done_button_pressed() -> void:
	# TODO: this should long term be handled by a command which interacts with the run state
	Commands.clear_poi(_poi_data)
	assert(_poi_data.weapons.size() == 1)
	Commands.add_item_to_inventory(_poi_data.weapons[0])
	get_tree().paused = false
