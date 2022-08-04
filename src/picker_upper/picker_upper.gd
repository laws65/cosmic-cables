extends Area2D


export var ship_path: NodePath
onready var ship := get_node(ship_path) as Ship


func _physics_process(_delta: float) -> void:
	for ground_item in get_overlapping_bodies():
		ground_item = ground_item as GroundItem
		if ground_item.picked_up or not ground_item.allow_pickup:
			continue

		if ship.team != 0 and ground_item.get_item_representing().type % 4 == 0:
			continue

		var item := ground_item.get_item_representing() as Item
		var successfully_added := ship.quick_add_to_inventory(item)
		if successfully_added:
			ground_item.pickup()
			if ship is Player:
				SignalBus.emit_signal("player_item_pickup", ground_item.get_item_representing())


func _on_Ship_death() -> void:
	set_physics_process(false)
