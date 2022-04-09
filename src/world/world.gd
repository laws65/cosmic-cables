extends Node2D

var asteroid = load("res://src/asteroid/asteroid.tscn")

func _ready() -> void:
	$Camera2D.target = $Player

	for i in range (1, 20):
		var asteroid_instance = asteroid.instance()
		randomize()
		asteroid_instance.position = Vector2(
			rand_range(100, 1180),
			rand_range(100, 620)
		)
		add_child(asteroid_instance)

	$CanvasLayer/UI/Inventory.set_ship($Player)
