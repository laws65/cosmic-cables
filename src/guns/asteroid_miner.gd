extends Node
class_name AsteroidMiner


static func mine(miner: Node2D, asteroid: Asteroid, clip_poly: Polygon2D) -> void:
	var asteroid_points = asteroid.get_points()
	var clip_points = _get_clip_points(miner, asteroid, clip_poly)
	var result = Geometry.clip_polygons_2d(asteroid_points, clip_points)

	if result.size() == 0:
		asteroid.queue_free()
	else:
		var new_asteroid_points = result.pop_front()
		asteroid.set_points(new_asteroid_points)

		for other_new_asteroid_points in result:
			var new_asteroid := asteroid.duplicate() as Asteroid
			asteroid.get_parent().add_child(new_asteroid)
			new_asteroid.set_points(other_new_asteroid_points)


static func _get_clip_points(miner: Node2D, asteroid: Asteroid, clip_poly: Polygon2D) -> PoolVector2Array:
	# relative to asteroid
	var clip_points := PoolVector2Array()
	for point in clip_poly.polygon:
		var global_point := miner.to_global(point * clip_poly.scale)
		var asteroid_local_point := asteroid.to_local(global_point)
		clip_points.push_back(asteroid_local_point)
	return clip_points
