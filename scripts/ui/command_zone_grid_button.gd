extends Button
class_name CommandZoneButton

var coords: Vector2i

func _get_drag_data(_at_position: Vector2) -> Variant:
	var command_zone_cell := State.run_state.command_zone.get_cell(coords.x, coords.y)
	
	if command_zone_cell.disabled or !command_zone_cell.ship or command_zone_cell.ship.is_flagship:
		print("cannot drag")
		return null
	
	modulate.a = 0.3
	
	var cell_disabled := command_zone_cell.disabled
	print("getting drag data. Cell at " + str(coords) + " is disabled=" + str(cell_disabled))
	var preview_texture_rect := TextureRect.new()
	preview_texture_rect.texture = command_zone_cell.ship.ui_icon
	preview_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
	preview_texture_rect.custom_minimum_size = Vector2(30, 30)
	set_drag_preview(preview_texture_rect)
	
	var draggable_data = {"type": Data.ItemType.SHIP, "coords": coords}
	
	return draggable_data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	var command_zone_cell := State.run_state.command_zone.get_cell(coords.x, coords.y)
	
	if command_zone_cell.disabled:
		return false
	
	if data["type"] != Data.ItemType.SHIP:
		return false
	
	if coords == data["coords"]:
		return false
	
	if command_zone_cell.ship and command_zone_cell.ship.is_flagship:
		return false
	
	print("valid drop")
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Commands.swap_cz_cells(coords.x, coords.y, data["coords"].x, data["coords"].y)

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1
