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

	#quick_add_to_inventory(load("res://src/guns/laser_gun/laser_gun.tres").duplicate())
	quick_add_to_inventory(load("res://src/guns/energy_gun/energy_gun.tres").duplicate())
	connect("death", SignalBus, "_on_Player_death")


func _input(event: InputEvent) -> void:
	if event.is_action_released("fire"):
		holding_shooting = false

	if (event.is_action_pressed("toggle_build_mode")
	and not get_node("/root/World/CanvasLayer/UI/Inventory").visible
	and not Game.building_menu_up):
		if mode == Mode.NORMAL:
			set_mode(Mode.BUILD)
		else:
			set_mode(Mode.NORMAL)

var holding_shooting := false


func _physics_process(_delta: float) -> void:
	if has_gun() and mode == Mode.NORMAL:
		if not Game.menus_visible() and holding_shooting:
			var gun := get_gun()
			if gun.automatic or Input.is_action_just_pressed("fire"):
				gun.shoot(get_global_mouse_position())


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire"):
		holding_shooting = true


func set_mode(new_mode: int) -> void:
	if mode == new_mode:
		return

	emit_signal("mode_changed", new_mode)
	mode = new_mode


func hit(hitter: Node2D, damage: float) -> void:
	damage *= 0.0

	.hit(hitter, damage)


func die() -> void:
	.die()
	yield(get_tree().create_timer(2.0), "timeout")
	get_tree().paused = true


func get_elasticity() -> float:
	return 0.1
