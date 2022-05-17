extends Panel


signal tooltip_display_item(item)
signal set_held_item(item)

export var gun_slot_path: NodePath
onready var gun_slot := get_node(gun_slot_path) as TextureRect

export var storage_path: NodePath
onready var storage_slots := get_node(storage_path).get_children()

export var modules_path: NodePath
onready var modules_slots := get_node(modules_path).get_children()

var held_item: Item

var ship: Ship setget set_ship


func _ready() -> void:
	get_tree().call_group("inventory_slot", "setup_inventory_signals", self)


func set_ship(new_ship: Ship) -> void:
	ship = new_ship


func _on_show() -> void:
	_update_inventory_display()


func _on_hide() -> void:
	emit_signal("tooltip_display_item", null)


func _on_Slot_clicked(slot: InventorySlot) -> void:
	var item := get_slot_item(slot)
	# if not holding anything currently
	if (not has_held_item()
	# or if slot type matches item we're trying to put into slot
	or slot.type & held_item.type > 0):
		# swap held item and slot item
		var item_to_be_put_in := held_item
		slot.set_item(item_to_be_put_in)
		emit_signal("set_held_item", item)
		_put_item_in_slot(slot, item_to_be_put_in)

		if not has_held_item():
			emit_signal("tooltip_display_item", held_item)


func _put_item_in_slot(slot: TextureRect, item: Item) -> void:
	emit_signal("tooltip_display_item", null)

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
	and not has_held_item()):
		emit_signal("tooltip_display_item", item)


func has_held_item() -> bool:
	return is_instance_valid(held_item)


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
		modules_slot.set_item(modules_item)

	for j in ship.storage.size():
		var storage_item: Item = ship.storage[j]
		var storage_slot: TextureRect = storage_slots[j]
		storage_slot.set_item(storage_item)


func _on_Slot_hovered(slot: TextureRect) -> void:
	var slot_item := get_slot_item(slot)

	if (is_instance_valid(slot_item)
	and not has_held_item()):
		emit_signal("tooltip_display_item", slot_item)


func _on_Slot_unhovered(_slot: TextureRect) -> void:
	emit_signal("tooltip_display_item", null)


func _on_HeldItem_item_updated(new_held_item: Item) -> void:
	held_item = new_held_item


func get_slot_item(slot: TextureRect) -> Item:
	if slot == gun_slot:
		var gun = ship.get_gun()
		if is_instance_valid(gun):
			return gun.get_item()
	elif slot in modules_slots:
		var idx = modules_slots.find(slot)
		if 0 <= idx and idx < modules_slots.size():
			return ship.modules[idx]
	elif slot in storage_slots:
		var idx = storage_slots.find(slot)
		if 0 <= idx and idx < storage_slots.size():
			return ship.storage[idx]

	return null
