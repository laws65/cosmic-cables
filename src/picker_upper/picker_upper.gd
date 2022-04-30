extends Area2D


export var ship_path: NodePath
onready var ship := get_node(ship_path) as Ship


func _physics_process(_delta: float) -> void:
	for ground_item in get_overlapping_bodies():
		if ground_item.picked_up or not ground_item.allow_pickup:
			continue

		var item := ground_item.get_item_representing() as Item
		ship.add_to_inventory(item)
		ground_item.pickup()
