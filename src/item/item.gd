extends Resource
class_name Item

export(int, FLAGS, "module", "gun", "resource") var type
export var name: String = "DefaultModuleName"
export var description: String = "Default Module Description"
export var level: int = 0
export var icon: Texture
export(String, FILE, "*.tscn") var scene_path
var scene: Node


func get_scene() -> Node:
	if (not is_instance_valid(scene)
	and type & 4 == 0):
		scene = load(scene_path).instance()

	return scene


func get_type_string() -> String:
	var ret := ""

	# You FAILEDPASSED the exam
	if type & 1 > 0:
		ret += "Module"
	if type & 2 > 0:
		ret += "Gun"

	return ret
