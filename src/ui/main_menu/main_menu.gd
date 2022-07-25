extends CanvasLayer


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_Quit_button_up() -> void:
	get_tree().quit()


func _on_Play_button_up() -> void:
	get_tree().change_scene("res://src/world/world.tscn")


func _on_Settings_button_up() -> void:
	pass # Replace with function body.
