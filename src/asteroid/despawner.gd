extends Node2D


export var despawn_time_secs: int = 60 * 5


func _ready() -> void:
	$Timer.wait_time = despawn_time_secs
	$Timer.start()


func _on_Timer_timeout() -> void:
	owner.queue_free()


func _on_ShipDetector_body_entered(_body: Node) -> void:
	$Timer.stop()


func _on_ShipDetector_body_exited(_body: Node) -> void:
	if $ShipDetector.get_overlapping_bodies().empty():
		$Timer.start()
