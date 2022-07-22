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
var zoom_lerp_speed := 4.0
export var build_zoom: Vector2
onready var default_zoom := zoom

enum Mode {
	NORMAL,
	BUILD,
}

var mode: int = Mode.NORMAL


func _ready() -> void:
	SignalBus.connect("player_health_changed", self, "_on_Player_health_changed")
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")


# ideally, should be in process
# but causes massive jittering
# so idk what's going on
func _physics_process(delta: float) -> void:
	var desired_position := _get_desired_position()
	_move_to_desired_position(desired_position, delta)

	var desired_zoom := _get_desired_zoom()
	_zoom_to_desired_zoom(desired_zoom, delta)


	_soldat_style_camera_offsetting(delta)
	_handle_camera_shake(delta)


func _handle_camera_shake(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()



func _get_desired_position() -> Vector2:
	if is_instance_valid(target):
		return target.position
	return position


func _move_to_desired_position(desired_position: Vector2, delta) -> void:
	var modified_lerp_speed = lerp_speed * delta
	if mode == Mode.BUILD:
		modified_lerp_speed *= 0.01
	position = position.linear_interpolate(desired_position, modified_lerp_speed)


func _get_desired_zoom() -> Vector2:
	if mode == Mode.BUILD:
		return build_zoom
	return default_zoom


func _zoom_to_desired_zoom(desired_zoom: Vector2, delta: float) -> void:
	zoom = zoom.linear_interpolate(desired_zoom, zoom_lerp_speed * delta)


func _soldat_style_camera_offsetting(delta: float) -> void:
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


func add_trauma(amount):
	trauma = min(trauma + amount, 1.0)


func _shake():
	var amount = pow(trauma, trauma_power)
	shake_offset.x = max_offset.x * amount * rand_range(-0.5, 0.5)
	shake_offset.y = max_offset.y * amount * rand_range(-0.5, 0.5)


func _on_Player_health_changed(new_health: float, old_health: float) -> void:
	if new_health < old_health:
		add_trauma(old_health - new_health)


func _on_Player_mode_changed(new_mode: int) -> void:
	mode = new_mode
