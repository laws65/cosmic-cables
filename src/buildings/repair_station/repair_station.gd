extends Building


func _on_Area2D_body_entered(_body: Node) -> void:
	if connected_to_core:
		$AnimationPlayer.play("fade_in_ui")


func _on_Area2D_body_exited(_body: Node) -> void:
	if $Area2D.get_overlapping_bodies().empty() or not connected_to_core:
		$AnimationPlayer.play_backwards("fade_in_ui")


func _on_Button_button_up() -> void:
	var player := get_tree().get_nodes_in_group("player").front() as Player
	player.full_heal()


func remove_connection(c: Connection) -> void:
	.remove_connection(c)
	if not connected_to_core:
		$AnimationPlayer.play_backwards("fade_in_ui")


func add_connection(c: Connection) -> void:
	.add_connection(c)
	if connected_to_core and not $Area2D.get_overlapping_bodies().empty():
		$AnimationPlayer.play("fade_in_ui")
