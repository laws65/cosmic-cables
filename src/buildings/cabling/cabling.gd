extends Node2D


func set_target(start_building: Building, start_slot_idx: int, end_building: Building, end_slot_idx: int) -> void:
	var start_slot = start_building.get_plug(start_slot_idx)
	var end_slot = end_building.get_plug(end_slot_idx)
	$Start.global_position = start_slot.global_position
	$End.global_position = end_slot.global_position
	$Start.rotation_degrees = start_slot_idx * 90
	$End.rotation_degrees = end_slot_idx * 90

	$Start.position += (Vector2.RIGHT * 8).rotated($Start.rotation)
	$End.position += (Vector2.RIGHT * 8).rotated($End.rotation)

	$Line2D.points[0] = $Start.position + (Vector2.RIGHT * 8).rotated($Start.rotation)
	$Line2D.points[1] = $End.position + (Vector2.RIGHT * 8).rotated($End.rotation)

	$End.rotation -= PI
