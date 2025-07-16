extends AudioStreamPlayer

func _ready():
	var audio_stream = load("res://assets/sfx/Spin Button.mp3")
	if audio_stream:
		stream = audio_stream
		volume_db = 12
