extends PanelContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if not visible:
			#TODO: there is probably a better place to put this check
			#print("about to open menu. selected is ", str(State.run_state.selected_cz_coords.row), str(State.run_state.selected_cz_coords.col))
			if !State.run_state.selected_cz_coords:
				print("selecting flagship")
				Commands.select_flagship()
			show()
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false
