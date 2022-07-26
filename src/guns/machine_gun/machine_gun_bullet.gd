extends Area2D


var team: int

var speed = 300
var damage = 0.1

var shooter: Ship


func _ready() -> void:
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

	for body in get_overlapping_bodies():
		if (body is Asteroid
		or  body is Ship and team != body.team):
			body.hit(self, damage)
			$AnimationPlayer.play("impact")


func get_clip_poly() -> Polygon2D:
	return $AsteroidClipArea as Polygon2D
