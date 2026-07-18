extends Button

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if data["type"] != Data.ItemType.WEAPON:
		return false
	
	var curr_selected_cell := State.run_state.command_zone.get_cell(State.run_state.selected_cz_coords)
	print(State.run_state.selected_cz_coords)
	print(curr_selected_cell.ship)
	if get_index() >= curr_selected_cell.ship.weapon_slots.size():
		return false
	
	if curr_selected_cell.ship.weapon_slots[get_index()]:
		return false
	
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	Commands.add_weapon_to_ship(data["idx"], get_index())
	
