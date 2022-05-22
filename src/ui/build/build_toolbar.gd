extends Panel


enum Mode {
	NORMAL,
	BUILD,
}

var mode: int = Mode.NORMAL

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer


func _ready() -> void:
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")


func _on_Player_mode_changed(new_mode: int) -> void:
	if new_mode == Mode.BUILD:
		animation_player.play("slide")
	elif mode == Mode.BUILD:
		animation_player.play_backwards("slide")
	mode = new_mode
