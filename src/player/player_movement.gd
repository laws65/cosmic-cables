extends Node


var player: Player

var acceleration_speed := 300
var deceleration_speed := 180
var friction = 0.01
var steer_strength = 10
var velocity_cutoff := 5


func set_player(new_player: Player) -> void:
	player = new_player


func _physics_process(delta: float) -> void:
	if not is_instance_valid(player):
		return

	var input_direction := Input.get_axis("decelerate", "accelerate")

	add_acceleration(input_direction)
	apply_friction(input_direction)

	steer()

	player.velocity += player.acceleration * delta
	player.velocity = player.move_and_slide(player.velocity)

	player.acceleration = Vector2.ZERO


func steer() -> void:
	var steer_direction := Input.get_axis("turn_left", "turn_right")
	var steer: float = -lerp_angle(0, steer_direction * steer_strength, 1.0)

	player.rotation_degrees += steer


func add_acceleration(input_direction: float) -> void:
	if input_direction > 0.0:
		player.acceleration += player.transform.x * acceleration_speed
	elif input_direction < 0.0:
		player.acceleration -= player.transform.x * deceleration_speed


func apply_friction(input_direction: float) -> void:
	if input_direction == 0:
		player.acceleration -= lerp(player.velocity, Vector2.ZERO, friction)
