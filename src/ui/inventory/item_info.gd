extends Panel


func build_display(item: Item) -> void:
	if not is_instance_valid(item):
		return

	get_node("V/Name").text = item.name
	get_node("V/Subtext").text = "Level %s %s" % [item.level, item.get_type_string()]
	get_node("V/Description").text = item.description
