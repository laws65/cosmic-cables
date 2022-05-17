extends KinematicBody2D
class_name Ship


export var team: int = 0

signal module_added(module)
signal module_removed(module)

var velocity: Vector2
var acceleration: Vector2

var gun: Gun setget set_gun, get_gun
var modules: Array
var storage: Array

var modules_amount: int = 6
var storage_size: int = 16


func _ready() -> void:
	modules.resize(modules_amount)
	storage.resize(storage_size)


func set_gun(new_gun: Gun) -> void:
	if is_instance_valid(gun):
		print("deleting old gun")
		remove_child(gun)

	if is_instance_valid(new_gun):
		new_gun.set_ship(self)
		add_child(new_gun)

	gun = new_gun


func has_gun() -> bool:
	return is_instance_valid(gun)


func get_gun() -> Gun:
	return gun


func add_module(module_item: Item, index: int = -1) -> bool:
	if index >= modules_amount:
		return false

	if index == -1:
		for i in modules_amount:
			var m: Item = modules[i]
			if not is_instance_valid(m):
				index = i
				break
			# can't fit new module into modules
			if i + 1 == modules_amount:
				return false
	modules[index] = module_item

	if not is_instance_valid(module_item):
		return false

	var module: Module = module_item.get_scene()
	if is_instance_valid(module):
		emit_signal("module_added", module)
	return true


func remove_module(module_item: Item) -> void:
	if not is_instance_valid(module_item):
		return

	if module_item in modules:
		var index := modules.find(module_item)
		modules[index] = null

	var module: Module = module_item.get_scene()
	if is_instance_valid(module):
		emit_signal("module_removed", module)


func add_to_inventory(item: Item) -> bool:
	if not is_instance_valid(item):
		return false

	# if resource
	if item.type & 4 > 0:
		Game.add_unobtainium(item.level)
		return true

	# if doesn't have gun and is gun equip it
	if item.type & 2 > 0 and not has_gun():
		var new_gun := item.get_scene() as Gun
		if is_instance_valid(new_gun):
			set_gun(new_gun)
			return true

	# if is module attempt to add it
	if item.type & 1 > 0:
		var successful := add_module(item)
		if successful:
			return true

	# if has room in storage add it
	for storage_index in storage_size:
		var storage_item: Item = storage[storage_index]
		if not is_instance_valid(storage_item):
			storage[storage_index] = item
			return true

	return false


func hit(_hitter: Node2D = null) -> void:
	pass
