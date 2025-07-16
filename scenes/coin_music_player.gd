extends AudioStreamPlayer

func _ready():
	var audio_stream = load("res://assets/sfx/Money Count.mp3")
	if audio_stream:
		stream = audio_stream
		volume_db = 8
		audio_stream.loop = true
	play()

	var timer = Timer.new()
	timer.wait_time = 3.0
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	timer.start()


func _on_Timer_timeout():
	stop()
