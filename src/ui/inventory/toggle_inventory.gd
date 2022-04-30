extends Node


export var inventory_path: NodePath
onready var inventory := get_node(inventory_path) as Control

export var held_item_display_path: NodePath
onready var held_item_display := get_node(held_item_display_path) as Control

onready var animation_player := get_node("AnimationPlayer") as AnimationPlayer


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		if inventory.visible:
			if not held_item_display.has_item():
				animation_player.play("fade_out")
		else:
			animation_player.play("fade_in")
	elif (event.is_action_pressed("ui_cancel")
	and inventory.visible
	and not held_item_display.has_item()):
			animation_player.play("fade_out")


func _on_UI_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT
	and inventory.visible):
		var held_item = held_item_display.get_item()
		if is_instance_valid(held_item):
			# TODO don't go up tree
			get_node("../../../").create_ground_item(held_item)
			held_item_display.set_item(null)
		else:
			animation_player.play("fade_out")
