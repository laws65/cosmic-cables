extends Area2D


var speed = 150


func _ready() -> void:
	$Tween.interpolate_property(self, "speed", speed, speed*10, 1.0, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.interpolate_property(self, "scale", Vector2(0.8, 0.8), Vector2.ONE, 0.5, Tween.TRANS_BOUNCE, Tween.EASE_IN_OUT)
	$Tween.start()
	$Fired.emitting = true


func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta
	
	for body in get_overlapping_bodies():
		$AnimationPlayer.play("impact")
		break
