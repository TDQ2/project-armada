extends Button

var weapon_hover_scene := preload("res://scenes/ui/fleet_management/weapon_hover.tscn")


func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["type"] != Data.ItemType.WEAPON:
		return false

	var curr_selected_cell := State.run_state.command_zone.get_cell(
		State.run_state.selected_cz_coords
	)
	if get_index() >= curr_selected_cell.ship.weapon_slots.size():
		return false

	if curr_selected_cell.ship.weapon_slots[get_index()]:
		return false

	return true


func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Commands.add_weapon_to_ship(data["idx"], get_index())


func _make_custom_tooltip(_for_text: String) -> Object:
	var curr_selected_cell := State.run_state.command_zone.get_cell(
		State.run_state.selected_cz_coords
	)
	var weapon_slot := curr_selected_cell.ship.weapon_slots[get_index()]
	if weapon_slot != null:
		var weapon_hover: WeaponHover = weapon_hover_scene.instantiate()
		weapon_hover.setup(weapon_slot)
		return weapon_hover
	return null
