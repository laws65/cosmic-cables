extends Ship
class_name Player


func _ready() -> void:
	$PlayerMovement.set_player(self)
	$Gun.set_ship(self)
	$SquishOnShoot.set_target(self)


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed("fire"):
		$Gun.shoot()

	$Particles2D.set_active(velocity)
