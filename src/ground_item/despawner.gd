extends Node


export var resource_despawn_time_secs: int = 5
export var item_despawn_time_secs: int = 300


func _ready() -> void:
	yield(owner, "ready")

	# Is resource
	if owner.item_representing.type & 4 > 0:
		$Timer.start(resource_despawn_time_secs)
	else:
		$Timer.start(item_despawn_time_secs)


func _on_Timer_timeout() -> void:
	owner.queue_free()
