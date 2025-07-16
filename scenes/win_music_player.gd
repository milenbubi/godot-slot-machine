extends AudioStreamPlayer

func _ready():
	var audio_stream = load("res://assets/sfx/Small Girl Coin Yeah.ogg")
	if audio_stream:
		stream = audio_stream
		volume_db = 8
	play()
