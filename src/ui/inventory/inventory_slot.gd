extends TextureRect
class_name InventorySlot


signal clicked(slot)
signal hovered(slot)
signal unhovered(slot)

export(int, FLAGS, "module", "gun") var type

onready var item_display := get_node("Item") as TextureRect

var item: Item setget set_item
var mouse_in: bool


func set_item(new_item: Item) -> void:
	if is_instance_valid(new_item):
		item_display.set_texture(new_item.icon)
	else:
		item_display.set_texture(null)

	item = new_item


func _on_Slot_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT):
		emit_signal("clicked", self)


func _on_Slot_mouse_entered() -> void:
	mouse_in = true
	if is_instance_valid(item):
		emit_signal("hovered", self)


func _on_Slot_mouse_exited() -> void:
	mouse_in = false
	emit_signal("unhovered", self)


func setup_inventory_signals(inventory: Panel) -> void:
	connect("clicked", inventory, "_on_Slot_clicked")
	connect("hovered", inventory, "_on_Slot_hovered")
	connect("unhovered", inventory, "_on_Slot_unhovered")
