extends KinematicBody2D


var speed = 300


func _ready() -> void:
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(transform.x * speed * delta)

	if collision:
		queue_free()
