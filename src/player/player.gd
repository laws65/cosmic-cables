extends Ship
class_name Player


signal mode_changed(new_mode)

enum Mode {
	NORMAL,
	BUILD,
}

var mode: int = Mode.NORMAL


func _ready() -> void:
	connect("health_changed", SignalBus, "_on_Player_health_changed")
	connect("mode_changed", SignalBus, "_on_Player_mode_changed")

	add_to_inventory(load("res://src/guns/machine_gun/machine_gun.tres").duplicate())
	add_to_inventory(load("res://src/guns/energy_gun/energy_gun.tres").duplicate())


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_build_mode"):
		if mode == Mode.NORMAL:
			set_mode(Mode.BUILD)
		else:
			set_mode(Mode.NORMAL)


func _physics_process(_delta: float) -> void:
	if has_gun() and mode == Mode.NORMAL:
		if not Game.menus_visible() and Input.is_action_pressed("fire"):
			if gun.automatic or Input.is_action_just_pressed("fire"):
				gun.shoot(get_global_mouse_position())

	if Input.is_action_just_pressed("damage_self"):
		take_damage(0.5)


func set_mode(new_mode: int) -> void:
	if mode == new_mode:
		return

	emit_signal("mode_changed", new_mode)
	mode = new_mode
