extends Line2D


func _process(_delta: float) -> void:
	points[1] = get_local_mouse_position()
