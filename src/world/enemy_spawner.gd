extends Node


var old_unobtainium_amount := 0
var time := 5.0 * 60.0
var waves_done := 0
var wave_size := 1


func _ready() -> void:
	Game.connect("unobtainium_changed", self, "_on_Unobtainium_changed")


func _physics_process(delta: float) -> void:
	time -= delta
	if time <= 0.0:
		_spawn_new_enemy()
		time = 4.0 * 60.0


func _spawn_new_enemy() -> void:
	waves_done += 1
	var player := get_tree().get_nodes_in_group("player").front() as Player
	for _i in wave_size:
		var enemy_position := player.position + (Vector2.RIGHT * 400).rotated(player.global_rotation)
		var enemy_instance = load("res://src/enemy_ship/enemy_ship.tscn").instance()
		enemy_instance.position = enemy_position
		enemy_instance.target = player
		owner.add_child(enemy_instance)
	if wave_size == 1:
		Game.add_message_popup("Enemy incoming!!")
	else:
		Game.add_message_popup("Enemies incoming!! (%s)" % wave_size)
	if waves_done % 4 == 0:
		wave_size += 1


func _on_Unobtainium_changed(new_amount: int) -> void:
	var amount_gained := new_amount - old_unobtainium_amount
	if amount_gained > 0:
		time -= amount_gained * 0.0003

	old_unobtainium_amount = new_amount
