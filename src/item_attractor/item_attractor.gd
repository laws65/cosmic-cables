extends Area2D


var base_speed = 100
var close_speed = 400

onready var collision_shape := get_node("CollisionShape2D") as CollisionShape2D

export var ship_path: NodePath
onready var ship := get_node(ship_path) as Ship


func _physics_process(delta: float) -> void:
	var shape_radius: float = collision_shape.shape.radius

	for ground_item in get_overlapping_bodies():
		if not ground_item.allow_pickup:
			continue

		if not ship.can_fit_item(ground_item.get_item_representing()):
			continue

		if ship.team != 0 and ground_item.get_item_representing().type % 4 == 0:
			continue

		var distance: float = (global_position - ground_item.global_position).length()
		var distance_percent = distance / shape_radius

		var speed = lerp(base_speed, close_speed, distance_percent)
		# dont overshoot
		if speed * delta > distance:
			speed = distance / delta

		var direction = ground_item.global_position.direction_to(global_position)
		ground_item.velocity = direction * speed


func _on_Ship_death() -> void:
	set_physics_process(false)
