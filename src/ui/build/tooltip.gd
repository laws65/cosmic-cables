extends RichTextLabel


func build_tooltip_for(toolbar_item: ToolbarItem) -> void:
	var info := toolbar_item.building_info as BuildingInfo
	if not toolbar_item.unlocked:
		bbcode_text = "[b][center]?????[/center][/b]\nYou haven't unlocked this yet!"
	else:
		bbcode_text = \
"""[b][center] {name} [/center][/b]
{description}
Price: ${price}""".format({
	"name": info.building_name,
	"description": info.description,
	"price": Helpers.add_commas(info.price),
})


