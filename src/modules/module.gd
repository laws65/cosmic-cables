extends Node
class_name Module


export var item_resource: Resource setget ,get_item


func apply(_what) -> void:
	push_error("Must override this function")


func remove(_what) -> void:
	push_error("Must override this function")


func get_item() -> Item:
	return item_resource as Item
