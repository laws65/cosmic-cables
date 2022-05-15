extends Control


signal item_updated

onready var item_display := get_node("Item") as TextureRect

export var display_offset := Vector2(-30, -30)

var item: Item setget _on_set_item, get_item


func _process(_delta: float) -> void:
	rect_global_position = (
		get_global_mouse_position() + display_offset)


func get_item() -> Item:
	return item


func has_item() -> bool:
	return is_instance_valid(item)


func _on_set_item(new_item: Item) -> void:
	if is_instance_valid(new_item):
		item_display.set_texture(new_item.icon)
	else:
		item_display.set_texture(null)

	item = new_item
	emit_signal("item_updated", new_item)
