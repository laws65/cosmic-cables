extends StaticBody2D
class_name Building


# warning-ignore:unused_signal
signal death


func _ready() -> void:
	connect("death", self, "_on_die")


export var info: Resource


func _on_die() -> void:
	pass
