extends Area2D


var base_speed = 200
var close_speed = 600

onready var collision_shape := get_node("CollisionShape2D") as CollisionShape2D


func _physics_process(delta: float) -> void:
	var shape_radius: float = collision_shape.shape.radius

	for area in get_overlapping_areas():
		var distance: float = (global_position - area.global_position).length()
		var distance_percent = 1 - distance / shape_radius
		if distance_percent < 0:
			continue
		var distance_factor = distance_percent / 2
		var speed = distance_factor * close_speed + base_speed
		# dont overshoot
		if speed * delta > distance:
			speed = distance / delta
		var direction = area.global_position.direction_to(global_position)
		area.position += direction * speed * delta
