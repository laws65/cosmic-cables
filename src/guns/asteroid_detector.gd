tool
extends RayCast2D
class_name AsteroidDetector

export var cast_to_where := Vector2.RIGHT * 20

func _ready() -> void:
	collision_mask = 4
	enabled = true
	set_cast_to(cast_to_where)


func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
	if is_colliding():
		owner.position = get_collision_point()
