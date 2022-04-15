extends Area2D


var ship: Ship setget set_ship


func set_ship(new_ship: Ship) -> void:
	ship = new_ship


func _physics_process(_delta: float) -> void:
	for ground_item in get_overlapping_areas():
		if ground_item.picked_up:
			continue

		var item := ground_item.get_item_representing() as Item
		ship.add_to_inventory(item)
		ground_item.pickup()
