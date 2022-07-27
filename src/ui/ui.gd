extends Control
tool

func _ready() -> void:
	print_children_if_mouse_mode_stop(self)


func print_children_if_mouse_mode_stop(n):
	#n.mouse_filter = MOUSE_FILTER_PASS
	if n.mouse_filter == MOUSE_FILTER_STOP:
		print(n.name + "yep, parent " + str(n.get_parent()))
	for i in n.get_children():
		print_children_if_mouse_mode_stop(i)
