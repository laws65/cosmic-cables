extends Panel


export var gun_slot_path: NodePath
onready var gun_slot := get_node(gun_slot_path) as TextureRect

export var storage_path: NodePath
onready var storage_slots := get_node(storage_path).get_children()

export var modules_path: NodePath
onready var modules_slots := get_node(modules_path).get_children()

const item_info_offset := Vector2(20, 20)

# injected by ui scene
var held_item_display: Control

onready var item_info := get_node("ItemInfo") as Panel

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
	if (not is_instance_valid(held_item)
	# or if slot type matches item we're trying to put into slot
	or slot.type & held_item.type > 0):
		# swap held item and slot item
		slot.set_item(held_item)
		held_item_display.set_item(item)

		_put_item_in_slot(slot, held_item)


func _put_item_in_slot(slot: TextureRect, item: Item) -> void:
	item_info.hide()

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
	and not is_instance_valid(held_item_display.get_item())):
		_show_item_info(slot, item)


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
			print("setting module")
			modules_slot.set_item(modules_item)

	for j in ship.storage.size():
		var storage_item: Item = ship.storage[j]
		var storage_slot: TextureRect = storage_slots[j]
		if storage_item != storage_slot.get_item():
			storage_slot.set_item(storage_item)


func _on_Slot_hovered(slot: TextureRect) -> void:
	var slot_item := slot.get_item() as Item

	if (is_instance_valid(slot_item)
	and not is_instance_valid(held_item_display.get_item())):
		_show_item_info(slot, slot_item)


func _on_Slot_unhovered(_slot: TextureRect) -> void:
	item_info.hide()


func _show_item_info(slot: TextureRect, item: Item) -> void:
	item_info.build_display(item)
	item_info.rect_global_position = slot.rect_global_position + item_info_offset
	item_info.show()
