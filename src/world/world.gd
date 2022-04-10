extends Node2D

var asteroid = load("res://src/asteroid/asteroid.tscn")

func _ready() -> void:
	randomize()

	$Camera2D.target = $Player

	$CanvasLayer/UI/Inventory.set_ship($Player)

	for _i in 20:
		var asteroid_instance = asteroid.instance()
		asteroid_instance.position = Vector2(
			rand_range(100, 3000),
			rand_range(100, 2000)
		)
		add_child(asteroid_instance)
