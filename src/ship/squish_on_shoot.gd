extends Node
class_name SquishOnShoot


export(int, 0, 8) var squish_delay_frames = 0
export(float, 0.0, 1.0) var squish_up_speed = 0.8
export(float, 0.0, 1.0) var squish_reset_speed = 0.2
export var squish_max: Vector2 = Vector2(-0.5, 0.5)

var squish := 0.0
var reached_squish_max := false


func _physics_process(_delta: float) -> void:
	var target: Ship

	target = owner.get_ship()

	if not is_instance_valid(target):
		return

	for child in target.get_children():
		if child is Node2D and not child is CollisionShape2D:
			var new_scale := Vector2.ONE + (squish * squish_max)
			new_scale = new_scale.rotated(child.rotation)
			child.scale = new_scale

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
