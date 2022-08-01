extends RichTextLabel


func build_tooltip_for(toolbar_item: ToolbarItem) -> void:
	var info := toolbar_item.building_info as BuildingInfo
	if not toolbar_item.unlocked:
		bbcode_text = "[b][center]?????[/center][/b]\nYou haven't unlocked this yet!"
	else:
		bbcode_text = \
"""[b][center] {name} [/center][/b]
{description}
{price_text}""".format({
	"name": info.building_name,
	"description": info.description,
	"price_text": "Price: $%s" % Helpers.add_commas(info.price)
		if info.building_name != "Remove Tool" else "",
})


