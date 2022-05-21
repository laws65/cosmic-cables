extends Control


var scroll_speed := 3000
var display_amount: int
var target_amount: int


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_on_Unobtainium_changed")


func _process(_delta: float) -> void:
	$Label.text = str(display_amount)


func _on_Unobtainium_changed(new_amount: int) -> void:
	var time = abs(target_amount - new_amount) / scroll_speed
	var tween := get_tree().create_tween()
	tween.tween_property(self, "display_amount", new_amount, time)
	target_amount = new_amount
