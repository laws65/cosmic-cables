extends Panel


enum Mode {
	NORMAL,
	BUILD,
}

var mode: int = Mode.NORMAL

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer

var selected_plug_building: Building
var selected_plug: int


var tooltip_offset := Vector2(-24, -50)
var selected_building: BuildingInfo

func _ready() -> void:
	SignalBus.connect("plug_clicked", self, "_on_Plug_clicked")
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")
	SignalBus.connect("toolbar_item_building_setup", self, "_on_set_selected_building")
	get_tree().call_group("toolbar_item", "connect", "hovered", self, "_on_Toolbar_item_hovered")
	get_tree().call_group("toolbar_item", "connect", "unhovered", self, "_on_Toolbar_item_unhovered")
	get_tree().call_group("toolbar_item", "connect", "clicked", self, "_on_Toolbar_item_clicked")


func _on_Plug_clicked(building: Building, plug: int) -> void:
	if is_instance_valid(selected_plug_building):
		if selected_plug_building != building:
			var cabling = load("res://src/buildings/cabling/cabling.tscn").instance()
			cabling.position = building.get_plug(plug).global_position
			get_node("/root/World").add_child(cabling)
			cabling.set_target(building, plug, selected_plug_building, selected_plug)

			var connection := Connection.new()
			cabling.connection = connection
			connection.building_one = building
			connection.building_one_connection = plug
			connection.building_two = selected_plug_building
			connection.building_two_connection = selected_plug
			connection.cabling = cabling

			building.add_connection(connection)
			selected_plug_building.add_connection(connection)

			deselect_cable()
	else:
		selected_plug_building = building
		selected_plug = plug

		get_node("/root/World/Line2D").show()
		get_node("/root/World/Line2D").points[0] = selected_plug_building.get_plug(selected_plug).global_position


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_instance_valid(selected_building):
			SignalBus.emit_signal("toolbar_item_building_setup", null)
			deselect_cable()
		else:
			var player := get_tree().get_nodes_in_group("player").front() as Player
			player.set_mode(player.Mode.NORMAL)
			deselect_cable()

	if (event.is_action_pressed("right-click")
	and is_instance_valid(selected_building)):
		SignalBus.emit_signal("toolbar_item_building_setup", null)
		deselect_cable()


func _on_Toolbar_item_hovered(toolbar_item: ToolbarItem) -> void:
	$Tooltip.build_tooltip_for(toolbar_item)
	$Tooltip.rect_global_position = toolbar_item.rect_global_position + tooltip_offset - Vector2(0, $Tooltip.rect_size.y/2.0)
	$Tooltip.show()


func _on_Toolbar_item_unhovered(_toolbar_item: ToolbarItem) -> void:
	$Tooltip.hide()


func _on_Toolbar_item_clicked(toolbar_item: ToolbarItem) -> void:
	deselect_cable()
	if toolbar_item.unlocked:
		$Tooltip.hide()
		if toolbar_item.building_info.price <= Game.unobtainium_amount:
			SignalBus.emit_signal("toolbar_item_building_setup", toolbar_item.building_info)
		else:
			Game.add_message_popup("You can't afford to build this!")


func _on_Player_mode_changed(new_mode: int) -> void:
	deselect_cable()
	if new_mode == Mode.BUILD:
		animation_player.play("slide")
	elif new_mode == Mode.NORMAL:
		animation_player.play_backwards("slide")
		SignalBus.emit_signal("toolbar_item_building_setup", null)

	mode = new_mode


func _on_set_selected_building(building: BuildingInfo) -> void:
	selected_building = building



func deselect_cable() -> void:
	selected_plug_building = null
	get_node("/root/World/Line2D").hide()
	selected_plug = -1
