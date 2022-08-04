extends Area2D


var building_info: BuildingInfo
var can_build_colour := Color("3ca370")
var cant_build_colour := Color("eb564b")


onready var cabling_price := load("res://src/buildings/cabling/cabling.tres").price as int


func _ready() -> void:
	set_physics_process(false)
	set_process_input(false)
	SignalBus.connect("toolbar_item_building_setup", self, "build_display_for")


func _input(event: InputEvent) -> void:
	if not is_instance_valid(building_info):
		return
	if (building_info.building_name == "Remove Tool"
	and event.is_action_pressed("place")):
		for overlap in get_overlapping():
			if overlap is Building:
				overlap.queue_free()
				overlap.emit_signal("death")
				# warning-ignore:narrowing_conversion
				var refund_amount := floor(overlap.info.price * 0.5)
				Game.add_unobtainium(refund_amount)
				owner.add_cha_ching(overlap.position + Vector2.UP * 50, refund_amount)

			if overlap.get_parent() is Cabling:
				var cabling := overlap.get_parent() as Cabling
				cabling.queue_free()
				var b1 = cabling.connection.building_one
				if is_instance_valid(b1):
					b1.remove_connection(cabling.connection)
				var b2 = cabling.connection.building_two
				if is_instance_valid(b2):
					b2.remove_connection(cabling.connection)
		return

	if event.is_action_pressed("place"):
		if can_build():
			owner.build_building(building_info, global_position)
		elif Game.unobtainium_amount < building_info.price:
			Game.add_message_popup("You can't afford to build this!")
		elif overlapping():
			Game.add_message_popup("You can't build that there!")


func _process(_delta: float) -> void:
	var mouse_pos := get_global_mouse_position()
	position.x = stepify(mouse_pos.x, 16)
	position.y = stepify(mouse_pos.y, 16)


func build_display_for(building: BuildingInfo) -> void:
	building_info = building
	if is_instance_valid(building):
		show()
		set_physics_process(true)
		set_process_input(true)
	else:
		hide()
		set_physics_process(false)
		set_process_input(false)
		return
	$Sprite.texture = building.display
	if building.building_name == "Cabling":
		$CollisionShape2D.shape.extents = Vector2(6,6)
	else:
		var texture_size := Vector2(building.icon.get_width(), building.icon.get_height())
		$CollisionShape2D.shape.extents = texture_size / 2

func _physics_process(_delta: float) -> void:
	if building_info.building_name != "Remove Tool" and can_build():
		$Sprite.material.set_shader_param("color", can_build_colour)
	else:
		$Sprite.material.set_shader_param("color", cant_build_colour)
	if building_info.building_name == "Remove Tool":
		$Line2D.hide()


func can_build() -> bool:
	if not is_instance_valid(building_info):
		return false

	return not overlapping() and Game.unobtainium_amount >= building_info.price


func overlapping() -> bool:
	$Line2D.hide()
	var overlapping := get_overlapping()
	for i in overlapping:
		if i is TileMap:
			continue
		$Line2D.points[1] = $Line2D.to_local(i.global_position)
		$Line2D.show()
		break

	return not overlapping.empty()


func get_overlapping() -> Array:
	return get_overlapping_areas() + get_overlapping_bodies()
