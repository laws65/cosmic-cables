extends Building


func _on_Area2D_body_entered(body: Node) -> void:
	if is_connected_to_core():
		body.slowed = true

func _on_Area2D_body_exited(body: Node) -> void:
	if is_connected_to_core():
		body.slowed = false
