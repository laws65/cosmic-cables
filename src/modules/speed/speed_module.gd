extends Module
class_name SpeedModule


func apply(movement) -> void:
	movement.acceleration_speed += 100
	movement.steer_strength += 0.8
	movement.velocity_rotate_weight += 0.01


func remove(movement) -> void:
	movement.acceleration_speed -= 100
	movement.steer_strength -= 0.8
	movement.velocity_rotate_weight -= 0.01
