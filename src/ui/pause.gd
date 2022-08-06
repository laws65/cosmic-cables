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
			elif help_open():
				close_help()
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


func _on_Button_down() -> void:
	GlobalSoundManager.play("res://assets/sounds/kenney_interfacesounds/Audio/click_004.ogg")


func _on_Button_hovered() -> void:
	GlobalSoundManager.play("res://assets/sounds/kenney_interfacesounds/Audio/tick_002.ogg")


func _on_Help_button_up() -> void:
	open_help()


func open_help() -> void:
	$Help.show()


func help_open() -> bool:
	return $Help.visible


func close_help() -> void:
	$Help.hide()


func _on_PauseScreen_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT):
		close_help()
		close_settings()
