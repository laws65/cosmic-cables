extends Node2D
class_name Gun


signal shot()

export var item_resource: Resource
export var bullet_scene: PackedScene
export var automatic: bool
export(float, 0.01, 1.0) var firerate = 0.1
export(float, -60.0, 60.0) var inaccuracy = 0.0
export(float, 0.0, 180.0) var max_rotation = 0.0

var ship

onready var shoot_point := get_node("ShootPoint") as Position2D
onready var fire_timer := get_node("FireTimer") as Timer


func set_ship(new_ship) -> void:
	ship = new_ship


func get_ship():
	return ship


func shoot(target_position: Vector2) -> Node2D:
	if not can_shoot():
		return null

	if ship.is_player:
		Game.shots_fired += 1

	var bullet_instance = bullet_scene.instance() as Node2D

	bullet_instance.set_as_toplevel(true)

	bullet_instance.global_position = shoot_point.global_position
	bullet_instance.global_rotation = get_shoot_angle(target_position)

	get_parent().get_parent().add_child(bullet_instance)

	fire_timer.start(firerate)

	if is_instance_valid(ship):
		var ship_speed = ship.velocity.length()
		bullet_instance.speed += ship_speed
		var delta := get_physics_process_delta_time()
		bullet_instance.position += ship.transform.x * ship_speed * delta
		bullet_instance.team = ship.team
		bullet_instance.shooter = ship

	emit_signal("shot")

	return bullet_instance


func get_shoot_angle(target_position: Vector2) -> float:
	shoot_point.look_at(target_position)
	shoot_point.rotation_degrees = clamp(
		shoot_point.rotation_degrees, -max_rotation, max_rotation)
	shoot_point.rotation_degrees += rand_range(-inaccuracy, inaccuracy)

	return shoot_point.global_rotation


func can_shoot() -> bool:
	return fire_timer.is_stopped()


func get_item() -> Item:
	return item_resource as Item
