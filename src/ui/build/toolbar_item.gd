extends TextureRect
class_name ToolbarItem


signal clicked(me)
signal hovered(me)
signal unhovered(me)

export var building_info: Resource

var unlocked := false


func _ready() -> void:
	$BuildingIcon.texture = building_info.icon


func _physics_process(_delta: float) -> void:
	if Game.unobtainium_amount >= building_info.price:
		unlocked = true
		$BuildingIcon.material = null


func _on_BuildingIcon_gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseButton
	and event.is_pressed()
	and event.get_button_index() == BUTTON_LEFT):
		emit_signal("clicked", self)


func _on_BuildingIcon_mouse_entered() -> void:
	emit_signal("hovered", self)


func _on_BuildingIcon_mouse_exited() -> void:
	emit_signal("unhovered", self)
