extends KinematicBody2D
class_name Ship


export var is_player := false
export var team: int = 0

signal inventory_updated(array, slot, item)
signal module_added(module)
signal module_removed(module)
signal health_changed(new_health, old_health)
signal death()

var velocity: Vector2
var acceleration: Vector2

var gun_slot := [null]
var modules: Array
var storage: Array

var modules_amount: int = 6
var storage_size: int = 16

var health := 3.0

enum {
	MODULE = 1,
	GUN = 2,
	RESOURCE = 4,
}

var fortune_multiplier := 1.0
var maximum_health := 3.0
var damage_multiplier := 1.0


func _ready() -> void:
	connect("module_added", self, "_on_module_added")
	connect("module_removed", self, "_on_module_removed")
	modules.resize(modules_amount)
	storage.resize(storage_size)


func set_gun_item(gun_item: Item) -> void:
	var gun: Gun
	if is_instance_valid(gun_item):
		gun = gun_item.get_scene()
	set_gun(gun)


func set_gun(new_gun: Gun) -> void:
	var old_gun := get_gun()
	if is_instance_valid(old_gun):
		remove_child(old_gun)

	if is_instance_valid(new_gun):
		new_gun.set_ship(self)
		add_child(new_gun)

	gun_slot = [new_gun]


func has_gun() -> bool:
	return is_instance_valid(get_gun())


func get_gun() -> Gun:
	return gun_slot[0]


func find_empty_slot_in_array(array: Array) -> int:
	for i in array.size():
		var item := array[i] as Item
		if not is_instance_valid(item):
			return i
	return -1


func set_module(module_item: Item, index: int) -> void:
	if index >= modules_amount:
		return

	var old_module_item := modules[index] as Item

	if is_instance_valid(old_module_item):
		var old_module := old_module_item.get_scene() as Module
		if is_instance_valid(old_module):
			emit_signal("module_removed", old_module)

	modules[index] = module_item

	if is_instance_valid(module_item):
		var module: Module = module_item.get_scene()
		if is_instance_valid(module):
			emit_signal("module_added", module)


func add_to_inventory(array: Array, slot: int, item: Item) -> void:
	assert(slot >= 0, "Invalid index for item")
	assert(slot < array.size(), "Invalid index for item")

	if array == modules:
		set_module(item, slot)
	elif array == storage:
		storage[slot] = item
	elif array == gun_slot:
		set_gun_item(item)

	emit_signal("inventory_updated", array, slot, item)


func quick_add_to_inventory(item: Item) -> bool:
	if not is_instance_valid(item):
		return false

	# if resource
	if item.type & RESOURCE > 0:
		Game.add_unobtainium(item.level)
		return true

	var target_array: Array
	var target_index: int

	# if doesn't have gun and is gun equip it
	if item.type & GUN > 0 and not has_gun():
		target_array = gun_slot
		target_index = 0

	# if is module attempt to add it
	elif item.type & MODULE > 0:
		var modules_index := find_empty_slot_in_array(modules)
		if modules_index >= 0:
			target_array = modules
			target_index = modules_index

	if not target_array:
		# if has room in storage add it
		var storage_index := find_empty_slot_in_array(storage)
		if storage_index >= 0:
			target_array = storage
			target_index = storage_index

	if target_array:
		add_to_inventory(target_array, target_index, item)
		return true

	return false


func hit(_hitter: Node2D, damage: float) -> void:
	take_damage(damage)


func die() -> void:
	if has_gun():
		get_gun().hide()
	_drop_all_items()

	emit_signal("death")
	$AnimationPlayer.play("die")


func take_damage(damage: float) -> void:
	var old_health := health
	health -= damage
	emit_signal("health_changed", health, old_health)
	if health <= 0.0:
		die()


func can_fit_item(item: Item) -> bool:
	if not is_instance_valid(item):
		return false

	if item.type & RESOURCE > 0:
		return true

	if find_empty_slot_in_array(storage) >= 0:
		return true

	if (item.type & GUN > 0
	and find_empty_slot_in_array(gun_slot) >= 0):
		return true

	if (item.type & MODULE > 0
	and find_empty_slot_in_array(modules) >= 0):
		return true

	return false


func _on_module_added(module: Module) -> void:
	if not is_instance_valid(module):
		return

	if module is FortuneModule:
		fortune_multiplier += 0.5

	elif (module is EnergyModule
	or module is PowerModule):
		module.apply(self)


func _on_module_removed(module: Module) -> void:
	if not is_instance_valid(module):
		return

	if module is FortuneModule:
		fortune_multiplier -= 0.5

	elif (module is EnergyModule
	or module is PowerModule):
		module.remove(self)


func full_heal() -> void:
	var health_needed = maximum_health - health
	take_damage(-health_needed)


func _drop_all_items() -> void:
	for item in gun_slot + storage + modules:
		if not is_instance_valid(item):
			continue

		var item_resource: Item
		if item is Resource:
			item_resource = item
		else:
			item_resource = item.item_resource
		var ground_item := owner.create_ground_item(item_resource) as GroundItem
		ground_item.position = position

	gun_slot.fill(null)
	storage.fill(null)
	modules.fill(null)
