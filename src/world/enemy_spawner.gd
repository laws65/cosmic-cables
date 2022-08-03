extends Node


var old_unobtainium_amount := 0
var time := 5.0 * 60.0


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_on_Unobtainium_changed")


func _physics_process(delta: float) -> void:
	print(time)
	time -= delta
	if time <= 0.0:
		_spawn_new_enemy()
		time = 4.0 * 60.0


func _spawn_new_enemy() -> void:
	pass


func _on_Unobtainium_changed(new_amount: int) -> void:
	var amount_gained := new_amount - old_unobtainium_amount
	if amount_gained > 0:
		time -= amount_gained * 0.0003

	old_unobtainium_amount = new_amount
