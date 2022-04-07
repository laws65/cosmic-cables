extends Node


export var inventory_path: NodePath
onready var inventory := get_node(inventory_path) as Control

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("open_inventory")
	and not inventory.visible):
		animation_player.play("fade")
	elif (event.is_action_pressed("ui_cancel")
	and inventory.visible):
		animation_player.play_backwards("fade")


func _on_UI_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT
	and inventory.visible):
		animation_player.play_backwards("fade")
