extends ColorRect


func _ready() -> void:
	SignalBus.connect("player_death", self, "_on_Player_die")


func _on_Player_die() -> void:
	$AnimationPlayer.play("fade_in")
	$Panel/VBoxContainer/VBoxContainer/Asteroids.text %= str(Game.asteroids_mined)
	$Panel/VBoxContainer/VBoxContainer/Kills.text %= str(Game.enemies_killed)
	$Panel/VBoxContainer/VBoxContainer/ShotsFired.text %= str(Game.shots_fired)
	$Panel/VBoxContainer/VBoxContainer/BuildingsPlace.text %= str(Game.buildings_placed)


func _on_MainMenu_button_up() -> void:
	Game.clear_stats()
	get_tree().paused = false
	get_tree().change_scene("res://src/ui/main_menu/main_menu.tscn")


func _on_Quit_button_up() -> void:
	get_tree().quit()
