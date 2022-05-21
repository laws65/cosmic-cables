extends Node


signal unobtainium_changed(unobtainium_amount)

var unobtainium_amount := 0

var inventory_path := NodePath("../World/CanvasLayer/UI/Inventory")


func menus_visible() -> bool:
	var inventory = get_node_or_null(inventory_path)
	if is_instance_valid(inventory) and inventory.visible:
		return true
	return false


func add_unobtainium(amount: int) -> void:
	unobtainium_amount += amount
	emit_signal("unobtainium_changed", unobtainium_amount)
