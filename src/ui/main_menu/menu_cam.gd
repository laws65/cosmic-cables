extends Camera2D


#func _ready() -> void:
	#get_node("../ParallaxBackground").show()


func _process(_delta: float) -> void:
	position = get_viewport().get_mouse_position()
