extends Ship


var min_distance = 100

var slowed := false
var acceleration_speed := 300
var deceleration_speed := 180
var friction := 0.01
var steer_strength := 2.5
var velocity_cutoff := 5
var velocity_rotate_weight := 0.01

const rotation_cutoff := 0.1

enum {
	ATTACK,
	IDLE,
	INVESTIGATE,
}

var custom_name: String

var mode = IDLE

var target: Node2D

var investigate_position: Vector2
var max_distance_from_target := 20000
var min_investiage_distance := 20


func _ready() -> void:
	set_gun_item(load("res://src/guns/machine_gun/machine_gun.tres").duplicate())


func _physics_process(delta: float) -> void:
	#rotation += 100 * delta
	#var input_direction := 0

	#add_acceleration(input_direction)
	#apply_friction(input_direction)

	if mode == ATTACK:
		if not is_instance_valid(target):
			var new_target = find_new_target()
			if not new_target:
				mode = IDLE
				return
			else:
				target = new_target

		var target_position = target.global_position - target.velocity * delta * 3

		var direction_to_target = to_global($ShipNavigation.recalculate(target_position))

		steer_towards(direction_to_target)
		if transform.x.dot(direction_to_target) > 0.99:
			var gun := get_gun()
			if is_instance_valid(gun):
				gun.shoot(target_position)

		velocity = transform.x * 200

		if target_position.distance_squared_to(global_position) > pow(max_distance_from_target, 2):
			mode = INVESTIGATE
			investigate_position = target_position
	elif mode == IDLE:

		velocity = Vector2.ZERO
	elif mode == INVESTIGATE:
		var direction_to_target = to_global($ShipNavigation.recalculate(investigate_position))
		steer_towards(direction_to_target)
		velocity = transform.x * 200

		if global_position.distance_squared_to(investigate_position) < pow(min_investiage_distance, 2):
			mode = IDLE

	velocity = move_and_slide(velocity)


func steer_towards(target_position) -> void:
	var direction_to_player = global_position.direction_to(target_position)
	var steer_direction := 0.0
	if abs(transform.x.angle_to(direction_to_player)) > rotation_cutoff:
		steer_direction = sign(transform.x.cross(direction_to_player))
	var steer: float = deg2rad(steer_direction * steer_strength)
	rotation += steer

	var rotated_velocity := velocity.rotated(steer)
	velocity = lerp(velocity, rotated_velocity, velocity_rotate_weight)


func add_acceleration(input_direction: float) -> void:
	if input_direction > 0.0:
		acceleration += transform.x * acceleration_speed
	elif input_direction < 0.0:
		acceleration -= transform.x * deceleration_speed


func apply_friction(input_direction: float) -> void:
	if input_direction == 0:
		acceleration -= lerp(velocity, Vector2.ZERO, friction)


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if (not is_instance_valid(target)
	or body.global_position.distance_squared_to(global_position)
	< target.global_position.distance_squared_to(global_position)):
		target = body
		mode = ATTACK


func find_new_target() -> Node2D:
	var new_target: Node2D
	var overlapping_bodies = $EnemyDetector.get_overlapping_bodies()
	if overlapping_bodies:
		new_target = overlapping_bodies.pop_front()
		for i in overlapping_bodies:
			if (i.global_position.distance_squared_to(global_position)
				< new_target.global_position.distance_squared_to(global_position)):
				new_target = i
	return new_target


func _on_EnemyDetector_body_exited(body: Node) -> void:
	return
	# warning-ignore:unreachable_code
	if body == target:
		target = find_new_target()
		if not target:
			mode = INVESTIGATE
			investigate_position = body.global_position


func _on_EnemyShip_death() -> void:
	Game.enemies_killed += 1
