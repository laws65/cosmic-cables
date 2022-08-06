extends Ship


var acceleration_speed := 300
var deceleration_speed := 180
var friction := 0.01
var steer_strength := 2.5
var velocity_cutoff := 5
var velocity_rotate_weight := 0.01

const rotation_cutoff := 0.1


var target: Node2D
var tick := 0


func _ready() -> void:
	set_gun_item(load("res://src/guns/machine_gun/machine_gun.tres").duplicate())


func _physics_process(delta: float) -> void:
	tick += 1
	if not is_instance_valid(target) or tick % 5 == 0:
		var new_target = find_new_target()
		if not new_target:
			return
		else:
			target = new_target

	if not is_instance_valid(target):
		var new_target = find_new_target()
		if not new_target:
			return
		else:
			target = new_target

	var target_position = target.global_position - target.velocity * delta * 3

	var direction_to_target = to_global($ShipNavigation.recalculate(target_position))

	steer_towards(direction_to_target)

	var rot_dir := Vector2(cos(rotation), sin(rotation))

	if rot_dir.dot((target.global_position - global_position).normalized()) > 0.9:
		var gun := get_gun()
		if is_instance_valid(gun):
			gun.shoot(target_position)

	var dot := abs(Vector2.RIGHT.dot(to_local(direction_to_target)))

	if dot > 0.5:
		acceleration += transform.x * acceleration_speed
	else:
		acceleration -= lerp(velocity, Vector2.ZERO, friction)

	_cap_speed(300)

	velocity += acceleration * delta
	acceleration = Vector2.ZERO

	if slowed:
		velocity = move_and_slide(velocity * Vector2(0.5, 0.5))
	else:
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


func _on_EnemyDetector_body_entered(body: PhysicsBody2D) -> void:
	if (not is_instance_valid(target)
	or body.global_position.distance_squared_to(global_position)
	< target.global_position.distance_squared_to(global_position)):
		target = body


func find_new_target() -> Node2D:
	var new_target: Node2D
	var overlapping_bodies = $EnemyDetector.get_overlapping_bodies()
	if overlapping_bodies:
		new_target = overlapping_bodies.pop_front()
		for i in overlapping_bodies:
			if i is Ship and new_target is Asteroid:
				new_target = i
				continue
			if (i.global_position.distance_squared_to(global_position)
				< new_target.global_position.distance_squared_to(global_position)):
				if not(i is Asteroid and new_target is Ship):
					new_target = i
	return new_target


func _cap_speed(max_speed: int) -> void:
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
