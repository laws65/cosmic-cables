extends Area2D


export var item_representing: Resource setget ,get_item_representing

var display_size := Vector2(16, 16)
var picked_up: bool


func _ready() -> void:
	var item_texture = item_representing.icon

	var display := get_node("Display") as Sprite
	display.texture = item_texture
	display.scale = display_size / item_texture.get_size()


func get_item_representing() -> Item:
	return item_representing as Item


func pickup() -> void:
	if picked_up:
		return

	picked_up = true
	$AnimationPlayer.play("pickup")
