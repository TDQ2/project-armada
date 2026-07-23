extends Resource
class_name PointsOfInterest

@export var all_pois: Array[PoiData]

func get_poi(idx: int) -> PoiData:
	return all_pois[idx]

func set_poi(idx: int, poi_data: PoiData) -> void:
	all_pois[idx] = poi_data

func add_poi(poi_data: PoiData) -> void:
	all_pois.append(poi_data)
