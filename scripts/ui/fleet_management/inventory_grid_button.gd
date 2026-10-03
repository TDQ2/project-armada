extends Button
class_name InventoryButton

var idx: int
var weapon_hover_scene := preload("res://scenes/ui/fleet_management/weapon_hover.tscn")

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

func _make_custom_tooltip(_for_text: String) -> Object:
	var inventory_cell := State.run_state.inventory.get_item(idx)
	if inventory_cell != null and inventory_cell is WeaponData:
		var weapon_data := inventory_cell as WeaponData
		var weapon_hover: WeaponHover = weapon_hover_scene.instantiate()
		weapon_hover.setup(weapon_data)
		return weapon_hover
	return null
