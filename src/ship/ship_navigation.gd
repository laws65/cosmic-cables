extends Node2D
class_name ShipNavigation

export var debug: bool = true
export var look_ahead = 100
export var num_rays = 16

# context array
var ray_directions = []
var interest = []
var danger = []

var chosen_dir = Vector2.ZERO


func _ready():
	interest.resize(num_rays)
	danger.resize(num_rays)
	ray_directions.resize(num_rays)
	for i in num_rays:
		var angle = i * TAU / num_rays
		ray_directions[i] = Vector2.RIGHT.rotated(angle)


func _draw():
	if not debug:
		return
	for i in ray_directions:
		if interest[ray_directions.find(i)]:
			draw_line(Vector2.ZERO, i * interest[ray_directions.find(i)] * look_ahead, Color.green, 2)
			draw_line(Vector2.ZERO, i * danger[ray_directions.find(i)] * look_ahead, Color.red, 2)
	draw_line(Vector2.ZERO, chosen_dir * look_ahead, Color.blue, 2)
	#for i in interest:
	#	return
		#draw_line(Vector2.ZERO, ray_directions[i] * look_ahead, Color.green, 2)
	#for i in danger:
	#	draw_line(Vector2.ZERO, Vector2.RIGHT.rotated(i) * look_ahead, Color.red, 2)


func calculate_interest(target_position: Vector2) -> Array:
	var _interest = []
	var direction = owner.to_local(target_position).normalized()
	for i in num_rays:
		var d = ray_directions[i].dot(direction)
		_interest.push_back(max(0, d))
	return _interest


func calculate_danger() -> Array:
	var _danger = []
	# Cast rays to find danger directions
	var space_state = get_viewport().get_world_2d().direct_space_state
	for i in num_rays:
		var result = space_state.intersect_ray(owner.position,
				owner.position + ray_directions[i].rotated(owner.rotation) * look_ahead,
				[owner], 2|4)
		_danger.push_back(1.0 if result else 0.0)
	return _danger


func choose_direction():
	# Eliminate interest in slots with danger
	for i in num_rays:
		if danger[i] > 0.0:
			interest[i] = 0.0
	# Choose direction based on remaining interest
	chosen_dir = Vector2.ZERO
	for i in num_rays:
		chosen_dir += ray_directions[i] * interest[i]
	chosen_dir = chosen_dir.normalized()


func recalculate(target_position: Vector2) -> Vector2:
	update()
	interest = calculate_interest(target_position)
	danger = calculate_danger()
	choose_direction()
	return chosen_dir
