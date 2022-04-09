extends KinematicBody2D
class_name Ship


signal gun_changed(old_gun, new_gun)

var velocity: Vector2
var acceleration: Vector2

var gun: Gun setget set_gun, get_gun
var modules: Array
var storage: Array

var modules_amount: int
var storage_size: int


func _ready() -> void:
	modules.resize(modules_amount)
	storage.resize(storage_size)


func set_gun(new_gun: Gun) -> void:
	if is_instance_valid(gun):
		remove_child(gun)
		gun.queue_free()

	if is_instance_valid(new_gun):
		new_gun.set_ship(self)
		add_child(new_gun)

	emit_signal("gun_changed", gun, new_gun)
	gun = new_gun


func has_gun() -> bool:
	return is_instance_valid(gun)


func get_gun() -> Gun:
	return gun
