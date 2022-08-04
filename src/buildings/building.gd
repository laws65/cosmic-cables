extends StaticBody2D
class_name Building


export var is_core := false
var connections := Array()
# warning-ignore:unused_signal
signal death
var connected_to_core := false

func _ready() -> void:
	connect("death", self, "_on_die")
	SignalBus.connect("player_mode_changed", self, "_on_Player_mode_changed")


func _on_Player_mode_changed(new_mode: int) -> void:
	if new_mode == 1:
		$PlugButtons.show()
	else:
		$PlugButtons.hide()


export var info: Resource


func _on_die() -> void:
	pass


func is_connected_to_core() -> bool:
	for i in get_connections():
		var connection := i as Connection
		if connection.building_one == self:
			if connection.building_two.is_core:
				return true
		if connection.building_two == self:
			if connection.building_one.is_core:
				return true

	return false


func get_connections() -> Array:
	return connections


func add_connection(connection: Connection) -> void:
	connections.push_back(connection)

	var my_plug: int
	if connection.building_one == self:
		my_plug = connection.building_one_connection
	elif connection.building_two == self:
		my_plug = connection.building_two_connection

	get_display_plug(my_plug).hide()
	update_is_connected_to_core()


func remove_connection(connection: Connection) -> void:
	connections.erase(connection)

	var my_plug: int
	if connection.building_one == self:
		my_plug = connection.building_one_connection
	elif connection.building_two == self:
		my_plug = connection.building_two_connection

	get_display_plug(my_plug).show()
	update_is_connected_to_core()


func _on_Plug_clicked(plug: int) -> void:
	SignalBus.emit_signal("plug_clicked", self, plug)


func get_display_plug(idx: int) -> Control:
	return $PlugButtons.get_child(idx) as Control


func get_plug(idx: int) -> Position2D:
	return $Plugs.get_child(idx) as Position2D


func update_is_connected_to_core() -> void:
	connected_to_core = is_connected_to_core()
