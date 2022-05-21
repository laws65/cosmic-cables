tool
extends KinematicBody2D
class_name Asteroid


onready var shape := get_node("Shape") as SS2D_Shape_Closed

export var should_gen: bool

export(float, 40, 200) var size = 40.0
export(float, 0.0, 0.1) var size_rand_percent = 0.0
export(float, 0.05, 0.15) var points_rand_percent = 0.1
export(float, 0, 10) var angle_rand = 0.0
export(float, 0, 50) var wave_magnitude = 1.0

var density = 0.03

onready var angular_velocity: float = rand_range(-0.2, 0.2)
var velocity: Vector2

var _mass: float


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


func _physics_process(delta: float) -> void:
	if Engine.editor_hint:
		if should_gen:
			_generate_shape(randi())
			should_gen = false
		return

	rotation += angular_velocity * delta
	var collision := move_and_collide(velocity * delta)
	if collision:
		if collision.collider is GroundItem:
			return
		var u1 := velocity
		var u2 := collision.get_collider_velocity()
		var m1 := get_mass()
		var m2 := 5.0
		var collider := collision.get_collider()
		if _quacks_like_a_duck(collider):
			m2 = collider.get_mass()
		# https://www.omnicalculator.com/physics/conservation-of-momentum
		velocity = (u1 * ((m1-m2)/(m1+m2)) + u2 * ((2.0*m2)/(m1+m2))) * get_elasticity()
		collider.velocity = (u1 * ((2*m1)/(m1+m2)) + u2 * ((m2-m1)/(m1+m2))) * get_elasticity()


func _quacks_like_a_duck(node) -> bool:
	return node.has_method("get_mass") and node.has_method("get_elasticity")


func hit(hitter: Node2D, _damage:=0.0) -> void:
	if is_instance_valid(hitter) and hitter.has_method("get_clip_poly"):
		mine(hitter, hitter.get_clip_poly())


func mine(miner: Node2D, clip_poly: Polygon2D) -> void:
	var asteroid_points = get_points()
	var clip_points = _get_relative_clip_points(miner, clip_poly)
	var result = Geometry.clip_polygons_2d(asteroid_points, clip_points)

	if result.size() == 0:
		queue_free()
	else:
		var new_points = result.pop_front()
		set_points(new_points)

		for new_asteroid_points in result:
			var new_asteroid := duplicate() as Asteroid
			get_parent().add_child(new_asteroid)
			new_asteroid.set_points(new_asteroid_points)


	var negative_polys = Geometry.intersect_polygons_2d(asteroid_points, clip_points)
	for poly in negative_polys:
		var area := _get_bounding_box_area(_get_bounding_box(poly))

		var clip_centre := Vector2.ZERO
		for point in clip_points:
			clip_centre += point
		clip_centre /= clip_points.size()

		var possible_points := poly as Array
		var points_amount := possible_points.size()
		possible_points.shuffle()

		var number_of_asteroid_chunks = area / 1000
		for _i in number_of_asteroid_chunks:
			if not is_queued_for_deletion():
				yield(get_tree(), "idle_frame")
			var rs = get_parent().create_ground_item(load("res://src/item/asteroid_chunk.tres").duplicate())
			var offset: Vector2 = possible_points[randi() % points_amount]
			offset = offset.linear_interpolate(clip_centre, rand_range(0.3, 1.0))
			rs.global_position = to_global(offset)
			rs.allow_pickup = true
			rs.rotation = randi()
			rs.item_representing.level = area


func _get_relative_clip_points(miner: Node2D, clip_poly: Polygon2D) -> PoolVector2Array:
	var clip_points := PoolVector2Array()
	for point in clip_poly.polygon:
		var global_point := miner.to_global(point * clip_poly.scale)
		var asteroid_local_point := to_local(global_point)
		clip_points.push_back(asteroid_local_point)
	return clip_points


func get_elasticity() -> float:
	return 0.8


func get_mass() -> float:
	return _mass


func get_rotation_damp() -> float:
	return size / 3.0


func set_points(points: PoolVector2Array) -> void:
	shape.clear_points()
	shape.add_points(points)
	_recalculate_mass()
	update()


func get_points() -> PoolVector2Array:
	var points := PoolVector2Array()
	for key in shape.get_all_point_keys():
		points.push_back(shape.get_point_position(key))
	var points_array = Array(points)
	# epic off by one error
	points_array.pop_back()
	return PoolVector2Array(points_array)


func _recalculate_mass() -> void:
	var points := get_points()
	var bb := _get_bounding_box(points)
	var area := _get_bounding_box_area(bb)
	_mass = area * density


func _get_bounding_box_area(bb: Rect2) -> float:
	return PI * bb.size.x  * bb.size.y * 0.25


func _get_bounding_box(points: Array) -> Rect2:
	var rect := Rect2()

	var _min: Vector2
	var _max: Vector2

	for i in points:
		if i.x > _max.x:
			_max.x = i.x
		if i.x < _min.x:
			_min.x = i.x
		if i.y > _max.y:
			_max.y = i.y
		if i.y < _min.y:
			_min.y = i.y

	rect.position = _min
	rect.end = _max

	return rect


func _generate_shape(asteroid_seed: int):
	var rand := RandomNumberGenerator.new()
	rand.set_seed(asteroid_seed)

	var new_points := PoolVector2Array()

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

		new_points.push_back(
			(Vector2(point_size, 0) * squash).rotated(point_angle))

	set_points(new_points)
