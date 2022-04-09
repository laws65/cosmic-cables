extends Node2D


func _ready() -> void:
	$Camera2D.target = $Player
	$CanvasLayer/UI/Inventory.set_ship($Player)
