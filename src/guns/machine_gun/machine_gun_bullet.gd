extends Area2D


var speed = 300


func _ready() -> void:
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
	for asteroid in get_overlapping_bodies():
		$AnimationPlayer.play("impact")
		break
