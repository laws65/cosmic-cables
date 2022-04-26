extends Node
class_name AsteroidMiner


static func mine(miner: Node2D, asteroid: Asteroid, clip_poly: Polygon2D) -> void:
	var asteroid_points = asteroid.get_points()
	var clip_points = _get_clip_points(miner, asteroid, clip_poly)
	var result = Geometry.clip_polygons_2d(asteroid_points, clip_points)
	if result.size() > 0:
		var new_asteroid_points = result[0]
		asteroid.set_points(new_asteroid_points)
	else:
		# TODO create another asteroid instance when asteroid gets mined in half
		asteroid.queue_free()


static func _get_clip_points(miner: Node2D, asteroid: Asteroid, clip_poly: Polygon2D) -> PoolVector2Array:
	# relative to asteroid
	var ret := PoolVector2Array()
	for point in clip_poly.polygon:
		var global_point := miner.to_global(point*clip_poly.scale)
		var asteroid_local_point := asteroid.to_local(global_point)
		ret.push_back(asteroid_local_point)
	return ret
