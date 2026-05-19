extends ItemData
class_name CrewData

@export var crew_type: Data.CrewType

func _init(name_: String, ui_icon_: Texture2D, crew_type_: Data.CrewType) -> void:
	name = name_
	ui_icon = ui_icon_
	crew_type = crew_type_
