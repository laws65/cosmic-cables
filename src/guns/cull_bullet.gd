extends Node
class_name CullBulletAfterTime


export(float, 2, 10) var cull_time = 5.0

onready var timer := Timer.new()
onready var visible := VisibilityNotifier2D.new()


func _ready() -> void:
	add_child(timer)
	add_child(visible)
	timer.one_shot = true
	timer.start(cull_time)


func _physics_process(delta: float) -> void:
	if timer.is_stopped() and not visible.is_on_screen():
		owner.queue_free()
