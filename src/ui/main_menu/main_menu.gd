extends CanvasLayer


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("pause"):
		$Control/Settings.close()


func _on_Quit_button_up() -> void:
	get_tree().quit()


func _on_Play_button_up() -> void:
	get_tree().change_scene("res://src/world/world.tscn")


func _on_Settings_button_up() -> void:
	$Control/Settings.open()
