extends Node2D


var ship: Ship setget set_ship

export var trail_cutoff = 100
export var trail_step = 100
export var dot_product_bias = 0.05


func set_ship(new_ship: Ship) -> void:
	ship = new_ship


func _physics_process(_delta: float) -> void:
	var velocity_length := ship.velocity.length()
	var dot_product := ship.transform.x.dot(ship.velocity.normalized())
	var trail_factor = velocity_length * (
		(dot_product) * (1 - dot_product_bias)
	)

	if trail_factor > trail_cutoff:
		for i in trail_factor / trail_step:
			if i >= get_child_count():
				break
			var p := get_child(i) as CPUParticles2D
			p.one_shot = false
			p.emitting = true
	else:
		for i in get_children():
			i.one_shot = true
