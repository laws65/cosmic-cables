extends ColorRect


func _ready() -> void:
	SignalBus.connect("player_death", self, "_on_Player_die")


func _on_Player_die() -> void:
	$AnimationPlayer.play("fade_in")
