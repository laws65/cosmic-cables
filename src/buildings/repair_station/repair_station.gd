extends Building


func _on_Area2D_body_entered(_body: Node) -> void:
	$AnimationPlayer.play("fade_in_ui")


func _on_Area2D_body_exited(_body: Node) -> void:
	if $Area2D.get_overlapping_bodies().empty():
		$AnimationPlayer.play_backwards("fade_in_ui")


func _on_Button_button_up() -> void:
	var player := get_tree().get_nodes_in_group("player").front() as Player
	player.full_heal()
