extends Ship
class_name Player


func _ready() -> void:
	var gun_instance = load("res://src/guns/machine_gun/machine_gun.tscn").instance()
	set_gun(gun_instance)
	storage[0] = load("res://src/guns/energy_gun/energy_gun.tres")


func _physics_process(_delta: float) -> void:
	if has_gun():
		if not Game.menus_visible() and Input.is_action_pressed("fire"):
			if gun.automatic or Input.is_action_just_pressed("fire"):
				gun.shoot(get_global_mouse_position())


func player():
	pass
