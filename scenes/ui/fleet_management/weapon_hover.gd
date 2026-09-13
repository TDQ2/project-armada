extends PanelContainer
class_name WeaponHover

@onready var weapon_name_label: Label = $VBoxContainer/WeaponName
@onready var damage_value_label: Label = $VBoxContainer/GridContainer/DamageValue
@onready var range_value_label: Label = $VBoxContainer/GridContainer/RangeValue
@onready var cooldown_value_label: Label = $VBoxContainer/GridContainer/CooldownValue
@onready var status_effects_label: Label = $VBoxContainer/GridContainer/StatusEffectsLabel
@onready var status_effects_container: HBoxContainer = $VBoxContainer/GridContainer/StatusEffectsContainer


var _weapon_data: WeaponData

func _ready() -> void:
	weapon_name_label.text = _weapon_data.name
	damage_value_label.text = str(_weapon_data.damage)
	range_value_label.text = str(_weapon_data.fire_range)
	cooldown_value_label.text = str(_weapon_data.cooldown_duration)
	if _weapon_data.status_effects.size() == 0:
		status_effects_label.hide()
		status_effects_container.hide()
	for status_effect: StatusEffectData in _weapon_data.status_effects:
		var status_effect_texture_rect = TextureRect.new()
		status_effect_texture_rect.texture = status_effect.icon
		status_effects_container.add_child(status_effect_texture_rect)

func setup(weapon_data: WeaponData) -> void:
	_weapon_data = weapon_data
