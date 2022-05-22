extends Module
class_name SpeedModule


var acceleration_speed_increase := 100.0
var steer_strength_increase := 0.8
var velocity_rotate_weight_increase := 0.01
var max_speed_increase := 300


func apply(movement) -> void:
	movement.acceleration_speed += acceleration_speed_increase
	movement.steer_strength += steer_strength_increase
	movement.velocity_rotate_weight += velocity_rotate_weight_increase
	movement.max_speed += max_speed_increase


func remove(movement) -> void:
	movement.acceleration_speed -= acceleration_speed_increase
	movement.steer_strength -= steer_strength_increase
	movement.velocity_rotate_weight -= velocity_rotate_weight_increase
	movement.max_speed -= max_speed_increase
