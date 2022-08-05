extends Node2D


export var num_players = 2
var bus = "Master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var pitches = []


class Sound:
	var sound_path: String
	var pitch_dif: int


func _ready():
	Settings.connect("setting_changed", self, "_on_Setting_changed")
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func play(sound_path, pitch_dif = 0):
	var sound = Sound.new()
	sound.sound_path = sound_path
	sound.pitch_dif = pitch_dif
	queue.append(sound)


func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		var sound: Sound = queue.pop_front()

		available[0].stream = load(sound.sound_path)
		available[0].pitch_scale = 1 + rand_range(0, sound.pitch_dif) - sound.pitch_dif
		available[0].play()
		available.pop_front()


func _on_Setting_changed(setting_name: String, value) -> void:
	if setting_name == "game_volume":
		var actual_volume = -50 + int(value) * 0.5
		if int(value) == 0:
			actual_volume = -100
		for player in get_children():
			player.volume_db = actual_volume
