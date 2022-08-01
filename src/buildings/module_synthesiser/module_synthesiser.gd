extends Building


func _on_Area2D_body_entered(body: Node) -> void:
	$AnimationPlayer.play("fade_in_ui")


func _on_Area2D_body_exited(body: Node) -> void:
	$AnimationPlayer.play_backwards("fade_in_ui")
