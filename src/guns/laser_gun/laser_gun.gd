extends Gun
class_name LaserGun


var laser_on: bool
var deactivate_time := 0.1
var damage := 0.0
var fire_rate := 0.2
var laser_width := 6.0
var activate_time := 0.2
var laser_length := 200.0

onready var tween := $Tween as Tween
var shooter

func _physics_process(_delta: float) -> void:
	shooter = ship
	if $Laser/RayCast2D.is_colliding():
		var col_point := $Laser.to_local($Laser/RayCast2D.get_collision_point()) as Vector2
		$Laser.points[1] = col_point
		$AsteroidClipArea.position = col_point + $Laser.position
		$Laser/BeamParticles.position = col_point
		$Laser/BeamParticles.emission_rect_extents.x = col_point.x / 2.0
		$Laser/CollisionParticles.global_rotation = $Laser/RayCast2D.get_collision_normal().angle()
		$Laser/CollisionParticles.position = col_point
		var col := $Laser/RayCast2D.get_collider() as Node2D
		col.hit(self, damage * ship.damage_multiplier)
	else:
		$Laser.points[1] = Vector2.RIGHT * laser_length
		$Laser/BeamParticles.position.x = laser_length / 2.0
		$Laser/BeamParticles.emission_rect_extents.x = laser_length / 2.0
		$Laser/CollisionParticles.global_rotation_degrees = -global_rotation_degrees
		$Laser/CollisionParticles.position.x = laser_length


func shoot(_target_position: Vector2) -> Node2D:
	if not can_shoot():
		return null

	if ship.is_player:
		Game.shots_fired += 1


	$TurnOffTimer.start(deactivate_time)

	if not laser_on:
		_turn_on_laser()

	return null


func _on_TurnOffTimer_timeout() -> void:
	_turn_off_laser()


func _turn_off_laser() -> void:
	laser_on = false
	#$AnimationPlayer.play("close_laser")
	tween.remove_all()
	tween.interpolate_property($Laser, "width", $Laser.width, 0, activate_time)
	tween.interpolate_property($Laser/RayCast2D, "enabled", true, false,
		0, Tween.TRANS_LINEAR, Tween.EASE_IN, activate_time)
	$Laser/BeamParticles.emitting = false
	$Laser/CollisionParticles.emitting = false
	tween.start()


func _turn_on_laser() -> void:
	laser_on = true
	var speed = activate_time * ((laser_width - $Laser.width) / laser_width)
	tween.remove_all()
	tween.interpolate_property($Laser, "width", $Laser.width, laser_width, speed)
	$Laser/RayCast2D.enabled = true
	$Laser/BeamParticles.emitting = true
	$Laser/CollisionParticles.emitting = true
	if $Laser/RayCast2D.is_colliding():
		$Laser.points[1] = $Laser.to_local($Laser/RayCast2D.get_collision_point())
	tween.start()
	#$AnimationPlayer.play("open_laser")


func get_clip_poly() -> Polygon2D:
	return $AsteroidClipArea as Polygon2D
