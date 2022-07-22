extends Area2D


var building_info: BuildingInfo
var can_build_colour := Color("3ca370")
var cant_build_colour := Color("eb564b")


func _ready() -> void:
	set_physics_process(false)
	set_process_input(false)
	SignalBus.connect("toolbar_item_building_setup", self, "build_display_for")


func _input(event: InputEvent) -> void:
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
		return
	$Sprite.texture = building.icon
	var texture_size := Vector2(building.icon.get_width(), building.icon.get_height())
	$CollisionShape2D.shape.extents = texture_size / 2


func _physics_process(_delta: float) -> void:
	if can_build():
		$Sprite.material.set_shader_param("color", can_build_colour)
	else:
		$Sprite.material.set_shader_param("color", cant_build_colour)


func can_build() -> bool:
	return not overlapping() and Game.unobtainium_amount >= building_info.price


func overlapping() -> bool:
	$Line2D.hide()
	var overlapping := get_overlapping_areas() + get_overlapping_bodies() as Array
	for i in overlapping:
		$Line2D.points[1] = $Line2D.to_local(i.global_position)
		$Line2D.show()
		break

	return not overlapping.empty()
