extends TextureRect
class_name InventorySlot


signal clicked(slot)
signal hovered(slot)

export(int, FLAGS, "module", "gun") var type

onready var item_display := get_node("Item") as TextureRect
onready var item_info := get_node("ItemInfo")

var item: Item setget set_item, get_item


func set_item(new_item: Item) -> void:
	if is_instance_valid(new_item):
		item_display.set_texture(new_item.icon)
		item_info.get_node("V/Name").text = new_item.name
		item_info.get_node("V/Description").text = new_item.description
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


func _on_Slot_mouse_entered() -> void:
	if is_instance_valid(item):
		emit_signal("hovered", self)


func _on_Slot_mouse_exited() -> void:
	item_info.hide()
