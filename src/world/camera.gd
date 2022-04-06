extends Camera2D


var target: Node2D
var lerp_delta := 0.5

func _physics_process(delta: float) -> void:
	if target:
		position = lerp(position, target.position, lerp_delta)
