extends Node


export var inventory_path: NodePath
onready var inventory := get_node(inventory_path) as Control

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("open_inventory")
	and not inventory.visible):
		animation_player.play("fade_in")
	elif (event.is_action_pressed("ui_cancel")
	and inventory.visible):
		if not is_instance_valid(inventory.held_item_display.get_item()):
			animation_player.play("fade_out")


func _on_UI_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT
	and inventory.visible):
		var held_item = inventory.held_item_display.get_item()
		if not is_instance_valid(held_item):
			animation_player.play("fade_out")
		else:
			get_node("../../../").create_ground_item(held_item)
			inventory.held_item_display.set_item(null)
