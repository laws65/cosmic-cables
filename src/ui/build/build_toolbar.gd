extends Panel


enum Mode {
	NORMAL,
	BUILD,
}

var mode: int = Mode.NORMAL

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer


var tooltip_offset := Vector2(-24, -50)


func _ready() -> void:
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")
	get_tree().call_group("toolbar_item", "connect", "hovered", self, "_on_Toolbar_item_hovered")
	get_tree().call_group("toolbar_item", "connect", "unhovered", self, "_on_Toolbar_item_unhovered")
	get_tree().call_group("toolbar_item", "connect", "clicked", self, "_on_Toolbar_item_clicked")


func _on_Toolbar_item_hovered(toolbar_item: ToolbarItem) -> void:
	$Tooltip.build_tooltip_for(toolbar_item)
	$Tooltip.rect_global_position = toolbar_item.rect_global_position + tooltip_offset - Vector2(0, $Tooltip.rect_size.y/2.0)
	$Tooltip.show()


func _on_Toolbar_item_unhovered(_toolbar_item: ToolbarItem) -> void:
	$Tooltip.hide()


func _on_Toolbar_item_clicked(toolbar_item: ToolbarItem) -> void:
	if toolbar_item.unlocked:
		$Tooltip.hide()
		if toolbar_item.building_info.price <= Game.unobtainium_amount:
			SignalBus.emit_signal("toolbar_item_building_setup", toolbar_item.building_info)
		else:
			Game.add_message_popup("You can't afford to build this!")


func _on_Player_mode_changed(new_mode: int) -> void:
	if new_mode == Mode.BUILD:
		animation_player.play("slide")
	elif new_mode == Mode.NORMAL:
		animation_player.play_backwards("slide")
		SignalBus.emit_signal("toolbar_item_building_setup", null)

	mode = new_mode
