tool
extends KinematicBody2D
class_name Asteroid


onready var shape := get_node("Shape") as SS2D_Shape_Closed

export var should_gen: bool

export(float, 40, 200) var size = 40
export(float, 0.0, 0.1) var size_rand_percent = 0.0
export(float, 0.05, 0.15) var points_rand_percent = 0.1
export(float, 0, 10) var angle_rand = 0.0
export(float, 0, 50) var wave_magnitude = 1.0

var density = 0.03

onready var angular_velocity: float = rand_range(-0.2, 0.2)
var velocity: Vector2


func _ready() -> void:
	if Engine.is_editor_hint():
		return

	size = rand_range(20, 200)
	size_rand_percent = rand_range(0.05, 0.1)
	angle_rand = rand_range(0, 10)
	wave_magnitude = rand_range(0, 50)
	_generate_shape(randi())
	velocity.x = rand_range(-5, 5)
	velocity.y = rand_range(-5, 5)


func _generate_shape(asteroid_seed: int):
	var rand := RandomNumberGenerator.new()
	rand.set_seed(asteroid_seed)
	shape.clear_points()

	var size_rand = size_rand_percent * size
	var points = points_rand_percent * size

	for point in points:
		var angle: float = TAU/float(points)*point
		var size_variation = (sin(angle) * wave_magnitude +
			rand.randf_range(-size_rand/2.0, size_rand/2.0))
		var angle_variation = deg2rad(
			rand.randf_range(-angle_rand/2.0, angle_rand/2.0))

		var point_size = size + size_variation
		var point_angle = angle + angle_variation

		var squash := Vector2(
			rand.randf_range(0.9, 1.1),
			rand.randf_range(0.9, 1.1))

		shape.add_point(
			(Vector2(point_size, 0) * squash).rotated(point_angle))


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		if should_gen:
			_generate_shape(randi())
			should_gen = false
		return

	rotation += angular_velocity * delta
	velocity = move_and_slide(velocity)


func get_mass() -> float:
	# approximate as circle
	return 2*PI*size * density


func get_rotation_damp() -> float:
	return size / 3.0
