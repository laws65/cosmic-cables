extends Ship
class_name Player


func _ready() -> void:
	connect("health_changed", SignalBus, "_on_Player_health_changed")

	add_to_inventory(load("res://src/guns/machine_gun/machine_gun.tres").duplicate())
	add_to_inventory(load("res://src/guns/energy_gun/energy_gun.tres").duplicate())


func _physics_process(_delta: float) -> void:
	if has_gun():
		if not Game.menus_visible() and Input.is_action_pressed("fire"):
			if gun.automatic or Input.is_action_just_pressed("fire"):
				gun.shoot(get_global_mouse_position())
	
	if Input.is_action_just_pressed("damage_self"):
		take_damage(0.5)
