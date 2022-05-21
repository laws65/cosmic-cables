extends HBoxContainer


var display_health := 3.0
var target_health := 3.0
var health := 3.0

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("damage_self"):
		take_damage(0.5)


func _process(delta: float) -> void:
	#var difference = target_health - display_health
	#var direction = sign(difference)
	#display_health += min(direction * difference, delta * direction)
	update_health_display(display_health, target_health)
	#print(display_health)


func update_health_display(display_health: float, target_health: float) -> void:
	var health_bars_amount := get_child_count()
	
	for i in health_bars_amount:
		var health_bar := get_child(i)
		var health_damage := 1.0 - clamp(target_health - i, 0, 1)
		var health_fill = clamp(display_health - i, 0, 1)
		health_bar.material.set_shader_param("health_damage", health_damage)
		health_bar.material.set_shader_param("health_fill", health_fill)


func take_damage(amount: float) -> void:
	health -= amount
	get_tree().create_tween().tween_property(self, "target_health", health, 0.05)
	yield(get_tree().create_timer(0.4), "timeout")
	get_tree().create_tween().tween_property(self, "display_health", target_health, 0.4)
