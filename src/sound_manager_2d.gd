extends Node2D
class_name SoundManager2D


export var num_players = 2
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.
var pitches = []


class Sound:
	var sound_path: String
	var pitch_dif: int


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer2D.new()
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
		randomize()
		available[0].pitch_scale = 1 + rand_range(-sound.pitch_dif/2.0, sound.pitch_dif/2.0)
		available[0].play()
		available.pop_front()
