extends StaticBody2D


# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collision_poly = self.get_node("CollisionPolygon2D")
	var shape_poly = self.get_node("SS2D_Shape_Closed")
	var poly_points: PoolVector2Array = PoolVector2Array([
		Vector2(0, 0),
		Vector2(10, 0),
		Vector2(0, 10),
		Vector2(10, 10),
	])
	collision_poly.set_polygon(poly_points)
	var point_template = shape_poly._points._points[1]
	shape_poly._points._points = {1: point_template}
	shape_poly._points._point_order = [
		1,
		2,
		3,
		4,
		5,
	]
	var point_positions = [
		Vector2(0, 20),
		Vector2(30, 0),
		Vector2(80, 30),
		Vector2(100, 70),
		Vector2(40, 80),
		Vector2(20, 40)
	]
	randomize()
	for i in range (1, 6):
		point_template.position = Vector2(
			point_positions[i].x + rand_range(1, 50),
			point_positions[i].y + rand_range(1, 50)
		)
		print(point_template.position)
		shape_poly._points._points[i] = point_template
	print("done")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
