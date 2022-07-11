extends Control


var scroll_speed := 10
var display_amount: int
var target_amount: int


onready var counter_label := get_node("H/Label") as Label


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_on_Unobtainium_changed")


func _process(delta: float) -> void:
	display_amount = lerp(display_amount, target_amount, scroll_speed * delta)
	var display_text := format_number(display_amount)
	counter_label.text = display_text


func _on_Unobtainium_changed(new_amount: int) -> void:
	target_amount = new_amount


func format_number(number: int) -> String:
	var num_digits := str(number).length()
	# warning-ignore:integer_division
	var magnitude = (num_digits - 1) / 3

	# less than 1000
	if magnitude < 1:
		return str(number)

	var number_names := [
		"",
		"Thousand",
		"Million",
		"Billion",
		"Trillion",
		"Quadrillion",
		"Quintillion",
		"Sextillion",
		"Septillion",
		"Octillion",
		"Nonillion",
		"Decillion",
	]
	var value := number / float(pow(10, magnitude*3))

	return "%.2f %s" % [value, number_names[magnitude]]
