extends Resource
class_name StatusEffectData

var type: Data.StatusEffectType
var name: String
var effect_desc: String
var duration: float
var icon: Texture2D

func _init(
	type_: Data.StatusEffectType, 
	name_: String, 
	effect_desc_: String, 
	duration_: float, 
	icon_: Texture2D) -> void:
	type = type_
	name = name_
	effect_desc = effect_desc_
	duration = duration_
	icon = icon_
	
