extends CPUParticles2D

export var velocity_cutoff: float



func set_active(velocity: Vector2) -> void:
	emitting = velocity.length() > velocity_cutoff
