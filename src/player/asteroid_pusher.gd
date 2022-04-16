extends Node
class_name AsteroidPusher


export var ship_path: NodePath
onready var ship := get_node(ship_path) as Ship


func _physics_process(_delta: float) -> void:
	var col := ship.get_last_slide_collision()
	if col == null:
		return

	var asteroid = col.collider
	if not asteroid.is_in_group("asteroid"):
		return

	var direction := ship.global_position.direction_to(asteroid.global_position)
	var force := ship.velocity * direction
	var acceleration = force / asteroid.get_mass()
	var rotate_amount = direction.cross(col.normal)

	var linear_angular_percentage = -direction.dot(col.normal)

	var angular_acceleration = rotate_amount / asteroid.get_rotation_damp()
	asteroid.velocity += linear_angular_percentage * acceleration
	asteroid.angular_velocity += angular_acceleration
