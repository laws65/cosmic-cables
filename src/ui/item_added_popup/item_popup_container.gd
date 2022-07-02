extends VBoxContainer


export var item_popup: PackedScene


func _ready() -> void:
	SignalBus.connect("player_item_pickup", self, "_on_Player_pickup_item")


func _on_Player_pickup_item(new_item: Item) -> void:
	for popup in get_children():
		if popup.items.front().name == new_item.name:
			popup.set_items(popup.items + [new_item])
			return

	var new_item_popup := item_popup.instance()
	add_child(new_item_popup)
	new_item_popup.set_items([new_item])
