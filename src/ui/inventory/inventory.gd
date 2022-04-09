extends Panel


export var gun_slot_path: NodePath
onready var gun_slot := get_node(gun_slot_path) as TextureRect

# injected by ui scene
var held_item_display: Control

var ship: Ship setget set_ship


func _ready() -> void:
	get_tree().call_group(
		"inventory_slot", "connect",
		"clicked", self, "_on_Slot_clicked")


func _process(_delta: float) -> void:
	held_item_display.rect_global_position = (
		get_global_mouse_position() + held_item_display.display_offset)


func set_ship(new_ship: Ship) -> void:
	ship = new_ship


func _on_show() -> void:
	if ship.has_gun():
		var gun := ship.get_gun()
		var item := gun.get_item()
		gun_slot.set_item(item)
	else:
		gun_slot.set_item(null)


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

		if slot == gun_slot:
			var gun: Gun
			if is_instance_valid(held_item):
				gun = load(held_item.scene_path).instance() as Gun
			ship.set_gun(gun)
