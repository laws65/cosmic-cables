extends Node


signal unobtainium_changed(unobtainium_amount)

var unobtainium_amount := 0
var asteroids_mined := 0
var enemies_killed := 0
var shots_fired := 0
var buildings_placed := 0

var inventory_path := NodePath("../World/CanvasLayer/UI/Inventory")

var health_display: Control


func menus_visible() -> bool:
	var inventory = get_node_or_null(inventory_path)
	if is_instance_valid(inventory) and inventory.visible:
		return true
	return false


func add_unobtainium(amount: int) -> void:
	unobtainium_amount += amount
	emit_signal("unobtainium_changed", unobtainium_amount)


func add_message_popup(message: String) -> void:
	var message_popup_instance = load("res://src/ui/message_popup/message_popup.tscn").instance()
	message_popup_instance.text = message
	get_node("/root/World/CanvasLayer/UI/MessagePopupContainer").add_child(message_popup_instance)


func clear_stats() -> void:
	unobtainium_amount = 0
	asteroids_mined = 0
	enemies_killed = 0
	shots_fired = 0
	buildings_placed = 0
