extends Building


func _on_Area2D_body_entered(body: Node) -> void:
	if connected_to_core:
		body.slowed = true


func _on_Area2D_body_exited(body: Node) -> void:
	if connected_to_core:
		body.slowed = false


func remove_connection(c: Connection) -> void:
	.remove_connection(c)
	if not connected_to_core:
		for i in $Area2D.get_overlapping_bodies():
			i.slowed = false
		$ForceFieldPhysicalThing.hide()


func add_connection(c: Connection) -> void:
	.add_connection(c)
	if connected_to_core:
		for i in $Area2D.get_overlapping_bodies():
			i.slowed = true
		$ForceFieldPhysicalThing.show()
