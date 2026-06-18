extends PanelContainer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		if not visible:
			show()
			get_tree().paused = true
		else:
			hide()
			get_tree().paused = false
