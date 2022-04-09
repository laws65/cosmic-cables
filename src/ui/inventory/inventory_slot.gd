extends TextureRect
class_name InventorySlot


signal clicked(slot)

export(int, FLAGS, "module", "gun") var type

onready var item_display := get_node("Item") as TextureRect

var item: Item setget set_item, get_item


func set_item(new_item: Item) -> void:
	if is_instance_valid(new_item):
		item_display.set_texture(new_item.icon)
	else:
		item_display.set_texture(null)

	item = new_item


func get_item() -> Item:
	return item


func _on_Slot_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT):
		emit_signal("clicked", self)
