extends Control


var scroll_speed := 3000
var display_amount: int
var target_amount: int


onready var counter_label := get_node("H/Label") as Label


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_on_Unobtainium_changed")


func _process(_delta: float) -> void:
	var display_text := format_number(display_amount)
	counter_label.text = display_text


func _on_Unobtainium_changed(new_amount: int) -> void:
	var time = abs(target_amount - new_amount) / scroll_speed
	var tween := get_tree().create_tween()
	tween.tween_property(self, "display_amount", new_amount, time)
	target_amount = new_amount


func format_number(number: int) -> String:
	var num_digits := str(number).length()
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
