extends Control


func _physics_process(delta: float) -> void:
	$Label.text = str(Game.unobtainium_amount)
