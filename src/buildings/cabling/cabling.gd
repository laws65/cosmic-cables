extends Node2D


func _ready() -> void:
	set_target(Vector2(50, 50))


func _physics_process(delta: float) -> void:
	set_target(get_global_mouse_position())


func set_target(pos: Vector2) -> void:
	pos = to_local(pos)

	if pos.length_squared() < pow(32, 2):
		pos = pos.normalized() * 32
	$Start.look_at(pos)
	$Start.position = (Vector2.RIGHT * 8).rotated($Start.transform.x.angle())

	$End.position = pos
	$End.look_at(Vector2.ZERO)
	$End.rotation -= PI
	$End.position += (Vector2.LEFT * 8).rotated($End.transform.x.angle())

	var angle_to_point := Vector2.ZERO.angle_to_point(pos)
	$Line2D.points[0] = (Vector2.RIGHT * 8).rotated($Start.transform.x.angle())
	$Line2D.points[1] = pos + (Vector2.LEFT * 8).rotated($End.transform.x.angle())
