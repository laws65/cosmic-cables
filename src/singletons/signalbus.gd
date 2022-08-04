extends Node


signal player_health_changed(new_health, old_health)
func _on_Player_health_changed(new_health: float, old_health: float) -> void:
	emit_signal("player_health_changed", new_health, old_health)


signal player_mode_changed(new_mode)
func _on_Player_mode_changed(new_mode: int) -> void:
	emit_signal("player_mode_changed", new_mode)

# warning-ignore:unused_signal
signal player_item_pickup(item)

# warning-ignore:unused_signal
signal toolbar_item_building_setup(toolbar_item)

signal player_death
func _on_Player_death() -> void:
	emit_signal("player_death")


# warning-ignore:unused_signal
signal plug_clicked(building, plug)
