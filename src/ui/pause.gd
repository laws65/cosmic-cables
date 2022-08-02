extends ColorRect


func _ready() -> void:
	unpause()
	close_settings()


func pause() -> void:
	show()
	get_tree().paused = true


func unpause(dont_hide = false) -> void:
	get_tree().paused = false

	if not dont_hide:
		hide()


func is_paused() -> bool:
	return get_tree().paused


func settings_open() -> bool:
	return $Settings.visible


func open_settings() -> void:
	$Settings.open()


func close_settings() -> void:
	$Settings.close()


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("pause"):
		if get_node("/root/World/CanvasLayer/UI/Inventory").visible:
			return
		if get_node("/root/World/CanvasLayer/UI/BuildToolbar").visible:
			return
		if Game.building_menu_up:
			return

		if is_paused():
			if settings_open():
				close_settings()
			else:
				unpause()
		else:
			pause()


func _on_Quit_button_up() -> void:
	# TODO add saving maybe ???
	unpause(true)
	Game.clear_stats()
	get_tree().change_scene("res://src/ui/main_menu/main_menu.tscn")


func _on_Back_button_up() -> void:
	unpause()


func _on_Settings_button_up() -> void:
	open_settings()
