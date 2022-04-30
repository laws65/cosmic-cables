extends Node2D


export var trail_cutoff := 100
export var trail_step := 100
export var dot_product_bias := 0.05

export var ship_path: NodePath
onready var ship := get_node(ship_path) as Ship


func _physics_process(_delta: float) -> void:
	var velocity_length := ship.velocity.length()

	if _should_show_fire_trail():
		var particles_amount = _get_particles_amount(velocity_length)
		for i in particles_amount:
			if i >= get_child_count():
				break
			var p := get_child(i) as CPUParticles2D
			p.initial_velocity = velocity_length
			p.one_shot = false
			p.emitting = true
	else:
		for c in get_children():
			c.one_shot = true


func _should_show_fire_trail() -> bool:
	if ship is Player:
		return Input.is_action_pressed("accelerate")
	return ship.velocity.length_squared() > trail_cutoff


func _get_particles_amount(velocity_length: float) -> int:
	var dot_product := ship.transform.x.dot(ship.velocity.normalized())
	var trail_factor = velocity_length * (
		1 - (dot_product) * (dot_product_bias)
	)
	var amount := int(ceil(trail_factor / trail_step))
	return amount
