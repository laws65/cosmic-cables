extends Area2D


var team: int

var speed = 250
var damage = 0.4

var shooter: Ship

onready var original_rotation := rotation

onready var wave_amplitude := rand_range(0.3, 0.5)
onready var wave_frequency := rand_range(0.1, 0.2)
var time := 0

func _physics_process(delta: float) -> void:
	time += 1

	position += transform.x * speed * delta

	rotation = original_rotation + sin(time * wave_frequency) * wave_amplitude

	var targets := $TargetDetector.get_overlapping_bodies() as Array
	for target in targets:
		if (target is Asteroid
		or target is Ship
		and team != target.team):
			var dir := position.direction_to(target.position)
			rotation = lerp(rotation, atan2(dir.y, dir.x), 0.1)
			break

	for body in get_overlapping_bodies():
		if (body is Asteroid
		or  body is Ship and team != body.team):
			body.hit(self, damage * shooter.damage_multiplier)
			$AnimationPlayer.play("impact")


func get_clip_poly() -> Polygon2D:
	return $AsteroidClipArea as Polygon2D
