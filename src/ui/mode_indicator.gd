extends Control


enum Mode {
	NORMAL,
	BUILD,
}

export var build_icon: Texture
export var combat_icon: Texture

onready var texture_display := get_node("TextureRect") as TextureRect


func _ready() -> void:
	_on_Player_mode_changed(Mode.NORMAL)
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")


func _on_Player_mode_changed(new_mode: int) -> void:
	if new_mode == Mode.BUILD:
		texture_display.texture = build_icon
	else:
		texture_display.texture = combat_icon
