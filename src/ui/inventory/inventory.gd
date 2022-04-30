extends Panel


export var gun_slot_path: NodePath
onready var gun_slot := get_node(gun_slot_path) as TextureRect

export var storage_path: NodePath
onready var storage_slots := get_node(storage_path).get_children()

export var modules_path: NodePath
onready var modules_slots := get_node(modules_path).get_children()

# injected by ui scene
var held_item_display: Control
var tooltip: Control

var ship: Ship setget set_ship


func _ready() -> void:
	get_tree().call_group("inventory_slot", "setup_inventory_signals", self)


func set_ship(new_ship: Ship) -> void:
	ship = new_ship


func _on_show() -> void:
	_update_inventory_display()


func _on_hide() -> void:
	pass


func _on_Slot_clicked(slot: InventorySlot) -> void:
	var item := slot.get_item()
	var held_item = held_item_display.get_item()
	# if not holding anything currently
	if (not held_item_display.has_item()
	# or if slot type matches item we're trying to put into slot
	or slot.type & held_item.type > 0):
		# swap held item and slot item
		slot.set_item(held_item)
		held_item_display.set_item(item)

		_put_item_in_slot(slot, held_item)


func _put_item_in_slot(slot: TextureRect, item: Item) -> void:
	tooltip.hide()

	if slot == gun_slot:
		var gun: Gun
		if is_instance_valid(item):
			gun = item.get_scene() as Gun
		ship.set_gun(gun)
	else:
		var modules_idx = modules_slots.find(slot)
		if modules_idx >= 0:
			var old_module: Item = ship.modules[modules_idx]
			ship.remove_module(old_module)
			ship.add_module(item, modules_idx)
		else:
			var storage_idx = storage_slots.find(slot)
			if storage_idx >= 0:
				ship.storage[storage_idx] = item

	if (is_instance_valid(item)
	and not held_item_display.has_item()):
		_show_tooltip(item)


func _update_inventory_display() -> void:
	if ship.has_gun():
		var gun := ship.get_gun()
		var item := gun.get_item()
		gun_slot.set_item(item)
	else:
		gun_slot.set_item(null)

	for i in ship.modules.size():
		var modules_item: Item = ship.modules[i]
		var modules_slot: TextureRect = modules_slots[i]
		if modules_item != modules_slot.get_item():
			modules_slot.set_item(modules_item)

	for j in ship.storage.size():
		var storage_item: Item = ship.storage[j]
		var storage_slot: TextureRect = storage_slots[j]
		if storage_item != storage_slot.get_item():
			storage_slot.set_item(storage_item)


func _on_Slot_hovered(slot: TextureRect) -> void:
	var slot_item := slot.get_item() as Item

	if (is_instance_valid(slot_item)
	and not held_item_display.has_item()):
		_show_tooltip(slot_item)


func _on_Slot_unhovered(_slot: TextureRect) -> void:
	tooltip.hide()


func _show_tooltip(item: Item) -> void:
	tooltip.build_display(item)
	tooltip.show()
