extends Node2D


export var build_effect: PackedScene
var asteroid = load("res://src/asteroid/asteroid.tscn")


func _ready() -> void:
	randomize()

	$Camera2D.target = $YSort/Player

	$CanvasLayer/UI/Inventory.set_ship($YSort/Player)


var max_asteroid_amount := 25


func _physics_process(_delta: float) -> void:
	if get_tree().get_nodes_in_group("asteroid").size() < max_asteroid_amount:
		var asteroid_instance = asteroid.instance()
		asteroid_instance.new = true
		var player := $YSort/Player as Player
		asteroid_instance.position = player.position + Vector2.RIGHT.rotated(randi()) * rand_range(500, 1500)
		add_child(asteroid_instance)


func create_ground_item(item: Item) -> KinematicBody2D:
	if not is_instance_valid(item):
		print("Item %s invalid" % item)
		print("Stack " + str(get_stack()))
		return null
	var ground_item_instance = load("res://src/ground_item/ground_item.tscn").instance()
	ground_item_instance.item_representing = item
	add_child(ground_item_instance)
	return ground_item_instance


func throw_ground_item(ground_item: GroundItem) -> void:
	var mouse_pos := get_viewport().get_mouse_position()
	var screen_centre := get_viewport_rect().size/2
	var throw_velocity := (mouse_pos - screen_centre) * 2.41

	ground_item.global_position = $Camera2D.global_position
	ground_item.velocity = throw_velocity


func build_building(building_info: BuildingInfo, pos: Vector2) -> void:
	Game.add_unobtainium(-building_info.price)
	Game.buildings_placed += 1

	if building_info.building_name != "Cabling":
		var scene_path := "res://src/buildings/{name}/{name}.tscn".format({"name": building_info.building_name.replace(" ", "_").to_lower()})
		var building_instance = load(scene_path).instance() as Building
		building_instance.global_position = pos
		add_child(building_instance)
	else:
		var tile_pos := $TileMap.world_to_map(pos) as Vector2
		$TileMap.set_cellv(tile_pos, 0)
		$TileMap.update_bitmask_area(tile_pos)

	add_cha_ching(pos + Vector2.UP * 50, -building_info.price)


func add_cha_ching(pos: Vector2, value: int) -> void:
	var cha_ching = load("res://src/ui/build/cha_ching.tscn").instance()
	cha_ching.set_value(value)
	cha_ching.rect_position = pos
	add_child(cha_ching)
