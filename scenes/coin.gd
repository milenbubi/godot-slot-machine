extends Node2D

@onready var coin_sprite = $Sprite2D
var frames: Array = []
var frame_index: int = 0
var frame_time: float = 0.02

func _ready():
	# Load coin assets
	for i in range(1, 19):
		var texture_path = load("res://assets/coin/SB_Coins_BangUp_00"+("0" if i <= 10 else "") + str(0 if i == 1 else (i - 1)) +  "_coin" + str(i) + ".png")
		frames.append(texture_path)
		
	play_animation()

func play_animation():
	frame_index = 0
	_update_frame()
	# Start a timer to cycle through the frames
	var timer = Timer.new()
	timer.wait_time = frame_time
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_update_frame"))
	add_child(timer)
	timer.start()

func _update_frame():
	coin_sprite.texture = frames[frame_index]
	frame_index += 1
	if frame_index >= frames.size():
		frame_index = 0  # loop back to the beginning
