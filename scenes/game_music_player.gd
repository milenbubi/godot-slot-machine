extends AudioStreamPlayer

func _ready():
	var audio_stream = load("res://assets/sfx/Intro Main Master.ogg")
	if audio_stream:
		stream = audio_stream
		volume_db = -4
		audio_stream.loop = true
	play()
