extends Building


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_update_display")


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("pause"):
		if $Control/CanvasLayer.visible:
			$Control/CanvasLayer.hide()
			yield(get_tree(), "idle_frame")
			Game.building_menu_up = false


func _on_OpenButton_button_up() -> void:
	$Control/CanvasLayer.show()
	Game.building_menu_up = true


func _on_Area2D_body_entered(_body: Node) -> void:
	if connected_to_core:
		$AnimationPlayer.play("fade_in_ui")


func _on_Area2D_body_exited(_body: Node) -> void:
	$AnimationPlayer.play_backwards("fade_in_ui")


func _update_display(amount: int) -> void:
	var has_enough := amount >= 500000
	get_node("%BuyButton").disabled = not has_enough
	var button_text := "Buy"
	if not has_enough:
		button_text = "You can't afford this!"
	get_node("%BuyButton").text = button_text


func _on_BuyButton_button_up() -> void:
	Game.add_unobtainium(-500000)
	var ship_instance := load("res://src/friendly_ship/friendly_ship.tscn").instance() as Ship
	ship_instance.position = position
	get_node("/root/World").add_child(ship_instance)
	var bot_name = get_node("%LineEdit").placeholder_text
	var input_text = get_node("%LineEdit").text
	if not input_text.strip_edges().empty():
		bot_name = input_text
	ship_instance.custom_name = bot_name


func remove_connection(c: Connection) -> void:
	.remove_connection(c)
	if not connected_to_core:
		$AnimationPlayer.play_backwards("fade_in_ui")


func add_connection(c: Connection) -> void:
	.add_connection(c)
	if connected_to_core and not $Area2D.get_overlapping_bodies().empty():
		$AnimationPlayer.play("fade_in_ui")
