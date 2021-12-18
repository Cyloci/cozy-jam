extends Node

func load_audio(path, volume_db=0):
	var audio_stream_player = AudioStreamPlayer.new()
	audio_stream_player.stream = load("res://assets/audio/" + path)
	audio_stream_player.volume_db = volume_db
	add_child(audio_stream_player)
	return audio_stream_player

func _ready():
	var wind = load_audio("ambience_wind.wav", -10)
	wind.play()
	var music = load_audio("Autumn Lullaby.wav", -20)
	music.play()

func get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)
