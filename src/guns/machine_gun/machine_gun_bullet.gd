extends Area2D


var speed = 300


func _ready() -> void:
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

	for body in get_overlapping_bodies():
		if body is Asteroid:
			AsteroidMiner.mine(self, body, $AsteroidClipArea)
		$AnimationPlayer.play("impact")
