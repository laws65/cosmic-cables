extends Node


signal setting_changed(setting_name, value)

var _settings := {
	"v-sync": true,
	"disable_screen_shake": false,
	"music_volume": 50,
	"game_volume": 50,
}


func _ready() -> void:
	parse_settings()


func parse_settings() -> void:
	var config := ConfigFile.new()
	var err := config.load("user://settings.cfg")

	if err == ERR_FILE_NOT_FOUND:
		save_settings()
		return

	if err != OK:
		print("Can't load _settings file with error code %s" % err)
		return

	for setting in _settings.keys():
		set_setting(setting, config.get_value("settings", setting))


func save_settings() -> void:
	var config := ConfigFile.new()
	for setting in _settings.keys():
		config.set_value("settings", setting, _settings[setting])
		config.save("user://settings.cfg")


func get_setting(setting_name: String):
	return _settings.get(setting_name)


func set_setting(setting_name: String, value) -> void:
	_settings[setting_name] = value

	if setting_name == "v-sync":
		OS.set_use_vsync(value)

	emit_signal("setting_changed", setting_name, value)
