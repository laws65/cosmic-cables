extends Ship


export var target_path: NodePath
onready var target = get_node(target_path)

var min_distance = 100


var acceleration_speed := 300
var deceleration_speed := 180
var friction := 0.01
var steer_strength := 2.5
var velocity_cutoff := 5
var velocity_rotate_weight := 0.01

const rotation_cutoff := 0.1


func _ready() -> void:
	add_to_inventory(load("res://src/guns/energy_gun/energy_gun.tres").duplicate())


func _physics_process(delta: float) -> void:
	if not is_instance_valid(target):
		return

	#rotation += 100 * delta
	#var input_direction := 0

	#add_acceleration(input_direction)
	#apply_friction(input_direction)
	var target_position = target.global_position - target.velocity * delta * 3

	var direction_to_player = global_position.direction_to(target_position)
	direction_to_player = 	to_global($ShipNavigation.recalculate(target_position))

	steer_towards(direction_to_player)
	if transform.x.dot(direction_to_player) > 0.99:
		pass
		#gun.shoot(target_position)

	#velocity += acceleration * delta
	#velocity = move_and_slide(velocity)
	velocity = transform.x * 200
	velocity = move_and_slide(velocity)
	#acceleration = Vector2.ZERO


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
