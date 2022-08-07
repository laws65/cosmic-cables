extends Building


var selected_module: Item


func _unhandled_key_input(event: InputEventKey) -> void:
	if event.is_action_pressed("pause"):
		if $Control/CanvasLayer.visible:
			$Control/CanvasLayer.hide()
			yield(get_tree(), "idle_frame")
			Game.building_menu_up = false


func _on_Area2D_body_entered(_body: Node) -> void:
	if connected_to_core:
		$AnimationPlayer.play("fade_in_ui")


func _on_Area2D_body_exited(_body: Node) -> void:
	$AnimationPlayer.play_backwards("fade_in_ui")


func _on_OpenButton_button_up() -> void:
	if not is_instance_valid(selected_module):
		_build_display_for("res://src/modules/speed/speed_module.tres")
	else:
		_build_display_for(selected_module.resource_path)
	$Control/CanvasLayer.show()
	Game.building_menu_up = true


func _on_Speed_button_down() -> void:
	_build_display_for("res://src/modules/speed/speed_module.tres")


func _on_Power_button_down() -> void:
	_build_display_for("res://src/modules/power/power_module.tres")


func _on_Energy_button_down() -> void:
	_build_display_for("res://src/modules/energy/energy_module.tres")


func _on_Fortune_button_down() -> void:
	_build_display_for("res://src/modules/fortune/fortune_module.tres")


func _build_display_for(module_resource_path: String) -> void:
	var module := load(module_resource_path) as Item
	selected_module = module

	for i in get_node("%ShopButtons").get_children():
		if i.name == module.name:
			i.grab_focus()

	get_node("%ModuleName").text = module.name + " Module"
	get_node("%Level").text = "Level %s Module" % module.level
	get_node("%Description").text = module.description
	get_node("%Price").text = "Price: $%s" % Helpers.add_commas(module.price)

	var buyable := module.price <= Game.unobtainium_amount
	get_node("%BuyButton").disabled = not buyable

	if buyable:
		get_node("%BuyButton").text = "Buy"
	else:
		get_node("%BuyButton").text = "You can't afford this!"


func _on_BuyButton_button_up() -> void:
	var player := get_tree().get_nodes_in_group("player").front() as Player
	var added := player.quick_add_to_inventory(selected_module)
	Game.add_unobtainium(-selected_module.price)
	if added:
		SignalBus.emit_signal("player_item_pickup", selected_module)
	else:
		var world := get_node("/root/World")
		var ground_item := world.create_ground_item(selected_module) as GroundItem
		ground_item.position = player.position

	for i in get_node("%ShopButtons").get_children():
		if i.name == selected_module.name:
			i.grab_focus()


func remove_connection(c: Connection) -> void:
	.remove_connection(c)
	if not connected_to_core:
		$AnimationPlayer.play_backwards("fade_in_ui")


func add_connection(c: Connection) -> void:
	.add_connection(c)
	if connected_to_core and not $Area2D.get_overlapping_bodies().empty():
		$AnimationPlayer.play("fade_in_ui")
