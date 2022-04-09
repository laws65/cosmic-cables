extends Ship
class_name Player


func _ready() -> void:
	var gun_instance = load("res://src/guns/energy_gun/energy_gun.tscn").instance()
	set_gun(gun_instance)
	$PlayerMovement.set_player(self)
	$SquishOnShoot.set_target(self)


func _physics_process(_delta: float) -> void:
	if has_gun() and Input.is_action_pressed("fire"):
		gun.shoot()

	$Particles2D.set_active(velocity)
