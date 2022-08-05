extends Node

var num_players = 1
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.


func _ready():
	pause_mode = PAUSE_MODE_PROCESS
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		p.pause_mode = PAUSE_MODE_INHERIT
		add_child(p)
		available.append(p)
		p.connect("finished", self, "_on_stream_finished", [p])
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)


func add_song(sound_path):
	queue.append(sound_path)


func _process(_delta):
	var music_volume = Settings.get_setting("music_volume")
	var actual_volume = -(110-music_volume)*0.7
	actual_volume = min(actual_volume, 0)
	if music_volume == 0:
		actual_volume = -100
	for i in get_children():
		i.volume_db = actual_volume
	# Play a queued sound if any players are available.
	if not queue.empty() and not available.empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()

