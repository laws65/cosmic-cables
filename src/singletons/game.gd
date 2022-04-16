extends Node


var inventory_path = "../World/CanvasLayer/UI/Inventory"


func menus_visible() -> bool:
	var inventory = get_node_or_null(inventory_path)
	if is_instance_valid(inventory) and inventory.visible:
		return true
	return false
