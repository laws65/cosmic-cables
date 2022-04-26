extends Camera2D


var target: Node2D
var lerp_speed := 30.0

var safe_spot = 0.2
var offset_lerp_speed := 15.0


func _process(delta: float) -> void:
	if is_instance_valid(target):
		position = lerp(position, target.position, lerp_speed * delta)
	
	var screen_size := get_viewport_rect().size
	var mouse_screen_pos := get_viewport().get_mouse_position()
	var new_offset := (mouse_screen_pos / screen_size) - Vector2(0.5, 0.5)

	if clamp(new_offset.x, -safe_spot, safe_spot) == new_offset.x:
		new_offset.x = 0.0
	else:
		new_offset.x -= sign(new_offset.x) * safe_spot

	if clamp(new_offset.y, -safe_spot, safe_spot) == new_offset.y:
		new_offset.y = 0.0
	else:
		new_offset.y -= sign(new_offset.y) * safe_spot

	offset = lerp(offset, new_offset, offset_lerp_speed * delta)
	# engine bug :)
	offset_h = offset.x
	offset_v = offset.y
