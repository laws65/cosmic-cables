extends Area2D


var speed = 300


func _ready() -> void:
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

	for body in get_overlapping_bodies():
		body.hit(self)
		$AnimationPlayer.play("impact")


func get_clip_poly() -> Polygon2D:
	return $AsteroidClipArea as Polygon2D
