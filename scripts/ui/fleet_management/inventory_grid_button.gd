extends Button
class_name InventoryButton

var idx: int

func _ready() -> void:
	idx = get_index()

func _get_drag_data(_at_position: Vector2) -> Variant:
	var inventory_cell := State.run_state.inventory.get_item(idx)
	
	if !inventory_cell:
		print("cannot drag")
		return null
	
	modulate.a = 0.3
	
	var preview_texture_rect := TextureRect.new()
	preview_texture_rect.texture = inventory_cell.ui_icon
	preview_texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
	preview_texture_rect.custom_minimum_size = Vector2(30, 30)
	set_drag_preview(preview_texture_rect)
	var dataType := Data.ItemType.CREW if inventory_cell is CrewData else Data.ItemType.WEAPON
	
	var draggable_data = {"type": dataType, "idx": idx}
	
	return draggable_data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["type"] == Data.ItemType.SHIP:
		#print("cannot drop ship")
		return false
	
	#print("valid drop")
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Commands.swap_inventory_cells(idx, data["idx"])

func _notification(what: int) -> void:
	if what == NOTIFICATION_DRAG_END:
		modulate.a = 1
