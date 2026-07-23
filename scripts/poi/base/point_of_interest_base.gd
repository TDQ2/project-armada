extends Node2D
class_name PoiBase

var poi_data: PoiData
var isPlayerNear: bool = false

@onready var poiUi: CanvasLayer = $PoiUi
@onready var collisionArea: Area2D = $CollisionArea

func _ready() -> void:
	print("running poi base ready")
	poiUi.hide()
	collisionArea.area_entered.connect(_show_ui)

func setup(poi_data_: PoiData):
	poi_data = poi_data_
	position = poi_data.position

func _show_ui(_area: Area2D) -> void:
	get_tree().paused = true
	poiUi.show()
