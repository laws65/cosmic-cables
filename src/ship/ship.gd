extends KinematicBody2D
class_name Ship


signal module_added(module)
signal module_removed(module)

var velocity: Vector2
var acceleration: Vector2

var gun: Gun setget set_gun, get_gun
var modules: Array
var storage: Array

var modules_amount: int = 6
var storage_size: int = 16

var modifiers: Dictionary


func _ready() -> void:
	modules.resize(modules_amount)
	storage.resize(storage_size)


func set_gun(new_gun: Gun) -> void:
	if is_instance_valid(gun):
		remove_child(gun)

	if is_instance_valid(new_gun):
		new_gun.set_ship(self)
		add_child(new_gun)

	gun = new_gun


func has_gun() -> bool:
	return is_instance_valid(gun)


func get_gun() -> Gun:
	return gun


func add_module(module_item: Item, index: int = -1) -> void:
	if index == -1:
		for i in modules_amount:
			var m: Item = modules[i]
			if not is_instance_valid(m):
				index = i
				break
			# can't fit new module into modules
			if i + 1 == modules_amount:
				return
	modules[index] = module_item

	if not is_instance_valid(module_item):
		return

	var module: Module = module_item.get_scene()
	if is_instance_valid(module):
		emit_signal("module_added", module)


func remove_module(module_item: Item) -> void:
	if not is_instance_valid(module_item):
		return

	if module_item in modules:
		var index := modules.find(module_item)
		modules[index] = null

	var module: Module = module_item.get_scene()
	if is_instance_valid(module):
		emit_signal("module_removed", module)
