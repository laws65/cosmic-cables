extends Control


export var display_offset: Vector2


func _process(_delta: float) -> void:
	rect_global_position = (
		get_global_mouse_position() + display_offset)


func _display_item(item: Item) -> void:
	print("signal received by tooltip")
	if not is_instance_valid(item):
		hide()
		return

	show()
	get_node("V/Name").text = item.name
	get_node("V/Subtext").text = "Level %s %s" % [item.level, item.get_type_string()]
	get_node("V/Description").text = item.description
