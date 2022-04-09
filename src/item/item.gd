extends Resource
class_name Item

export(int, FLAGS, "module", "gun") var type
export var name: String = "DefaultModuleName"
export var description: String = "Default Module Description"
export var level: int = 0
export var icon: Texture
export(String, FILE, "*.tscn") var scene_path
