extends PanelContainer


var items := []


onready var anim := get_node("AnimationPlayer") as AnimationPlayer


func set_items(new_items: Array) -> void:
	assert(not new_items.empty(), "Attemping to set items of popup to be empty")

	var first_item := new_items.front() as Item
	var item_name := first_item.name
	var quantity := new_items.size()
	var icon := first_item.icon

	get_node("H/Label").text = item_name
	get_node("H/MarginContainer/TextureRect/Label").text = str(quantity)
	get_node("H/MarginContainer/TextureRect").texture = icon

	anim.stop()
	anim.play("fade")

	items = new_items
