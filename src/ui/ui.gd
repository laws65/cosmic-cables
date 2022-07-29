extends Control
tool


func _ready() -> void:
	yes(self)


func yes(node):
	if "mouse_filter" in node:
		if node.mouse_filter == MOUSE_FILTER_STOP:
			node.mouse_filter = MOUSE_FILTER_IGNORE
			print(node.get_parent().name + " | " + node.name)

	for c in node.get_children():
		yes(c)
