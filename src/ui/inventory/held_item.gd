extends Control


onready var item_display := get_node("Item") as TextureRect

export var display_offset := Vector2(-30, -30)

var item: Item setget set_item, get_item


func set_item(new_item: Item) -> void:
	if is_instance_valid(new_item):
		item_display.set_texture(new_item.icon)
	else:
		item_display.set_texture(null)
	item = new_item


func get_item() -> Item:
	return item
