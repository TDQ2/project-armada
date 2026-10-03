class_name PoiBase
extends Node2D


var _poi_data: PoiData

@onready var _poi_ui: CanvasLayer = $PoiUi
@onready var _collision_area: Area2D = $CollisionArea


func _ready() -> void:
	_poi_ui.hide()
	_collision_area.area_entered.connect(_show_ui)


func setup(poi_data_: PoiData):
	_poi_data = poi_data_
	position = _poi_data.position


func _show_ui(_area: Area2D) -> void:
	get_tree().paused = true
	_poi_ui.show()
