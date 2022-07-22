extends TextureRect


export var step_size := 32
onready var offset := rect_min_size.x * 0.5

func _process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	rect_global_position.x = stepify(mouse_pos.x, step_size) - offset
	rect_global_position.y = stepify(mouse_pos.y, step_size) - offset

	for c in get_children():
		c.global_position = mouse_pos
