extends Control


func set_value(value: int) -> void:
	var colour: String
	if value > 0:
		colour = "#3ca370"
	else:
		colour = "#eb564b"

	$Text.bbcode_text = "[center][color={colour}] ${value} [/color][/center]" \
		.format({"colour": colour, "value": value})
