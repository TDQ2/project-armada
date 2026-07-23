extends PoiBase

@onready var unclearedSprite: Sprite2D = $UnclearedSprite
@onready var doneButton: Button = $PoiUi/TreasureUI/VBoxContainer/DoneButton
@onready var rewardTextureRect: TextureRect = $PoiUi/TreasureUI/VBoxContainer/RewardBoxContainer2/RewardTextureRect

func _ready() -> void:
	super()
	doneButton.pressed.connect(_handle_done_button_pressed)
	var uncleared_sprite_tween = create_tween()
	uncleared_sprite_tween.set_loops()
	uncleared_sprite_tween.tween_property(unclearedSprite, "frame", 2, 1.0)
	uncleared_sprite_tween.tween_property(unclearedSprite, "frame", 0, 1.0)

func setup(poi_data_: PoiData): #overwrites parents
	poi_data = poi_data_
	position = poi_data.position
	assert(poi_data.weapons.size() == 1)
	rewardTextureRect.texture = poi_data.weapons[0].ui_icon

func _handle_done_button_pressed() -> void:
	# TODO: this should long term be handled by a command which interacts with the run state
	Commands.clear_poi(poi_data)
	assert(poi_data.weapons.size() == 1)
	Commands.add_item_to_inventory(poi_data.weapons[0])
	get_tree().paused = false
