extends Node


signal player_health_changed(new_health, old_health)

func _on_Player_health_changed(new_health: float, old_health: float) -> void:
	emit_signal("player_health_changed", new_health, old_health)


signal player_mode_changed(new_mode)

func _on_Player_mode_changed(new_mode: int) -> void:
	emit_signal("player_mode_changed", new_mode)
