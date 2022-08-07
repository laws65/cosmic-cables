extends Module
class_name EnergyModule


func apply(ship) -> void:
	var old_health = ship.health
	var health_perc := float(ship.health) / float(ship.maximum_health)
	ship.maximum_health += 1.0
	ship.health = floor(health_perc * ship.maximum_health * 2) / 2.0

	if ship.is_player:
		_update_health_display(ship, old_health)


func remove(ship) -> void:
	var old_health = ship.health
	var health_perc := float(ship.health) / float(ship.maximum_health)
	ship.maximum_health -= 1.0
	ship.health = floor(health_perc * ship.maximum_health * 2) / 2.0

	if ship.is_player:
		_update_health_display(ship, old_health)


func _update_health_display(ship, old_health) -> void:
	Game.health_display.set_max_health(ship.maximum_health)
	Game.health_display._on_Player_health_changed(ship.health, old_health)
