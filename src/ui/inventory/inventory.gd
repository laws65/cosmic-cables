extends Panel


signal tooltip_display_item(item)
signal set_held_item(item)

onready var gun_slot := get_node("%GunSlot") as TextureRect
onready var storage_slots := get_node("%Storage").get_children()
onready var modules_slots := get_node("%Modules").get_children()

var held_item: Item

var ship: Ship setget set_ship

var player_dead := false


func _ready() -> void:
	get_tree().call_group("inventory_slot", "setup_inventory_signals", self)
	SignalBus.connect("player_death", self, "_on_Player_die")


func _on_Player_die() -> void:
	player_dead = true


func set_ship(new_ship: Ship) -> void:
	assert(is_instance_valid(new_ship))

	if is_instance_valid(ship):
		ship.disconnect("inventory_updated", self, "_on_Ship_inventory_updated")

	new_ship.connect("inventory_updated", self, "_on_Ship_inventory_updated")
	ship = new_ship


func _on_Ship_inventory_updated(array: Array, index: int, item: Item) -> void:
	var slot: InventorySlot
	if array == ship.storage:
		slot = storage_slots[index]
	elif array == ship.modules:
		slot = modules_slots[index]
	else:
		slot = gun_slot

	slot.set_item(item)
	if slot.mouse_in and not has_held_item():
		emit_signal("tooltip_display_item", item)



func _on_show() -> void:
	if not player_dead:
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
		emit_signal("set_held_item", item)
		_put_item_in_slot(slot, item_to_be_put_in)


func _put_item_in_slot(slot: InventorySlot, item: Item) -> void:
	emit_signal("tooltip_display_item", null)
	if slot == gun_slot:
		ship.add_to_inventory(ship.gun_slot, 0, item)
	else:
		var modules_idx = modules_slots.find(slot)
		if modules_idx >= 0:
			ship.add_to_inventory(ship.modules, modules_idx, item)
		else:
			var storage_idx = storage_slots.find(slot)
			if storage_idx >= 0:
				ship.add_to_inventory(ship.storage, storage_idx, item)

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
		var modules_slot: InventorySlot = modules_slots[i]
		modules_slot.set_item(modules_item)

	for j in ship.storage.size():
		var storage_item: Item = ship.storage[j]
		var storage_slot: InventorySlot = storage_slots[j]
		storage_slot.set_item(storage_item)


func _on_Slot_hovered(slot: InventorySlot) -> void:
	var slot_item := get_slot_item(slot)

	if (is_instance_valid(slot_item)
	and not has_held_item()):
		emit_signal("tooltip_display_item", slot_item)


func _on_Slot_unhovered(_slot: InventorySlot) -> void:
	emit_signal("tooltip_display_item", null)


func _on_HeldItem_item_updated(new_held_item: Item) -> void:
	held_item = new_held_item


func get_slot_item(slot: InventorySlot) -> Item:
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
