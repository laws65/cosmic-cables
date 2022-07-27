extends Module
class_name PowerModule


func apply(ship) -> void:
	ship.damage_multiplier += 0.5


func remove(ship) -> void:
	ship.damage_multiplier -= 0.5
