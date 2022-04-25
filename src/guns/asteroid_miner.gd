extends Node
class_name AsteroidMiner


export var clip_polygon_path: NodePath
onready var clip_poly := get_node(clip_polygon_path) as Polygon2D

export var miner_path: NodePath
onready var miner := get_node(miner_path) as Area2D


func _physics_process(_delta: float) -> void:
	var asteroids := miner.get_overlapping_bodies()
	for asteroid in asteroids:
		_mine_asteroid(asteroid)


func _mine_asteroid(asteroid: Asteroid) -> void:
	var asteroid_points = _get_asteroid_points(asteroid)
	var clip_points = _get_clip_points(asteroid)
	var result = Geometry.clip_polygons_2d(asteroid_points, clip_points)
	if result.size() > 0:
		var new_asteroid_points = result[0]
		_set_asteroid_points(asteroid, new_asteroid_points)
	else:
		# TODO create another asteroid instance when asteroid gets mined in half
		asteroid.queue_free()


func _get_asteroid_points(asteroid: Asteroid) -> PoolVector2Array:
	var points := PoolVector2Array()
	for key in asteroid.shape.get_all_point_keys():
		points.push_back(asteroid.shape.get_point_position(key))
	var points_array = Array(points)
	# epic off by one error
	points_array.pop_back()
	return PoolVector2Array(points_array)


func _get_clip_points(asteroid: Asteroid) -> PoolVector2Array:
	# relative to asteroid
	var ret := PoolVector2Array()
	for point in clip_poly.polygon:
		var global_point := miner.to_global(point*clip_poly.scale)
		var asteroid_local_point := asteroid.to_local(global_point)
		ret.push_back(asteroid_local_point)
	return ret


func _set_asteroid_points(asteroid: Asteroid, points: PoolVector2Array) -> void:
	asteroid.shape.clear_points()
	asteroid.shape.add_points(points)
