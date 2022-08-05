extends Control


var _pending_changes := Dictionary()


func load_settings() -> void:
	var v_sync = Settings.get_setting("v-sync")
	get_node("%VSyncButton").pressed = bool(v_sync)

	var disable_screen_shake = Settings.get_setting("disable_screen_shake")
	get_node("%DisableScreenShakeButton").pressed = bool(disable_screen_shake)

	var music_volume = Settings.get_setting("music_volume")
	get_node("%MusicVolumeSlider").value = int(music_volume)

	var game_volume = Settings.get_setting("game_volume")
	get_node("%GameVolumeSlider").value = int(game_volume)


func close() -> void:
	_pending_changes.clear()
	hide()


func _on_MusicVolume_value_changed(value: float) -> void:
	_pending_changes["music_volume"] = value
	get_node("%MusicVolumeLabel").text = str(value)


func _on_GameVolume_value_changed(value: float) -> void:
	_pending_changes["game_volume"] = value
	get_node("%GameVolumeLabel").text = str(value)


func _on_DisableScreenShake_toggled(button_pressed: bool) -> void:
	_pending_changes["disable_screen_shake"] = button_pressed


func _on_VSync_toggled(button_pressed: bool) -> void:
	_pending_changes["v-sync"] = button_pressed


func _on_Back_button_up() -> void:
	close()


func _on_Apply_button_up() -> void:
	apply_settings()


func apply_settings() -> void:
	for setting in _pending_changes.keys():
		Settings.set_setting(setting, _pending_changes[setting])

	if not _pending_changes.empty():
		Settings.save_settings()

	_pending_changes.clear()


func open() -> void:
	load_settings()
	show()


func _on_Button_down() -> void:
	GlobalSoundManager.play("res://assets/sounds/kenney_interfacesounds/Audio/click_004.ogg")


func _on_Button_hovered() -> void:
	GlobalSoundManager.play("res://assets/sounds/kenney_interfacesounds/Audio/tick_002.ogg")
