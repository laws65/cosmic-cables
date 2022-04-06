extends Node
class_name SquishOnShoot


export(int, 0, 8) var squish_delay_frames = 0
export(float, 0.0, 1.0) var squish_up_speed = 0.8
export(float, 0.0, 1.0) var squish_reset_speed = 0.2
export var squish_max: Vector2 = Vector2(-0.5, 0.5)

var squish := 0.0
var reached_squish_max := false
var target: Node2D


func set_target(new_target: Node2D) -> void:
	target = new_target


func _physics_process(_delta: float) -> void:
	if not target:
		return

	target.scale.x = 1 + (squish * squish_max.x)
	target.scale.y = 1 + (squish * squish_max.y)

	if reached_squish_max:
		squish = lerp(squish, 0, squish_reset_speed)
	else:
		squish = lerp(squish, 1, squish_up_speed)
		if (squish / 1.0) > 0.9:
			reached_squish_max = true


func _on_Gun_shot() -> void:
	for _i in squish_delay_frames:
		yield(get_tree(), "idle_frame")
	reached_squish_max = false
