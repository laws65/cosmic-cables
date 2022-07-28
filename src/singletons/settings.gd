extends Node


var _settings := {
	"v-sync": true,
	"disable_screen_shake": false,
	"music_volume": 100,
	"game_volume": 100,
}


func _ready() -> void:
	parse_settings()


func parse_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load("user://_settings.cfg")

	if err == ERR_FILE_NOT_FOUND:
		save_settings()
		return

	if err != OK:
		print("Can't load _settings file with error code %s" % err)
		return

	for setting in _settings.keys():
		_settings[setting] = config.get_value("_settings", setting)


func save_settings() -> void:
	var config := ConfigFile.new()
	for setting in _settings.keys():
		config.set_value("_settings", setting, _settings[setting])
		config.save("user://_settings.cfg")


func get_setting(setting_name: String):
	return _settings.get(setting_name)


func set_setting(setting_name: String, value) -> void:
	_settings[setting_name] = value
