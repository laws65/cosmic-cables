extends Camera2D


var target: Node2D
var lerp_speed := 0.5

func _physics_process(_delta: float) -> void:
	if is_instance_valid(target):
		position = lerp(position, target.position, lerp_speed)
