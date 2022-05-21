extends Camera2D


export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_offset = Vector2(0.6, 0.3)  # Maximum hor/ver shake in pixels.

var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].


var target: Node2D
var lerp_speed := 30.0

var safe_spot = 0.2
var offset_lerp_speed := 15.0
var shake_offset := Vector2.ZERO

# ideally, should be in process
# but causes massive jittering
# so idk what's going on
func _physics_process(delta: float) -> void:
	track_target(delta)
	soldat_style_camera_offsetting(delta)
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		shake()


func soldat_style_camera_offsetting(delta: float) -> void:
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

	offset = offset.linear_interpolate(new_offset, offset_lerp_speed * delta)
	# engine bug :)
	offset_h = offset.x
	offset_v = offset.y
	
	# apply shake offset
	offset += shake_offset


func track_target(delta: float) -> void:
	if is_instance_valid(target):
		position = lerp(position, target.position, lerp_speed * delta)


func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)


func shake():
	var amount = pow(trauma, trauma_power)
	shake_offset.x = max_offset.x * amount * rand_range(-0.5, 0.5)
	shake_offset.y = max_offset.y * amount * rand_range(-0.5, 0.5)
