extends Node2D


func _ready() -> void:
	$Camera2D.target = $Player
