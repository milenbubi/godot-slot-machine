extends HBoxContainer

var reel_scene = preload("res://scenes/reel.tscn")


func _ready() -> void:
	for i in range(Constants.TOTAL_REELS):
		var reel_instance = reel_scene.instantiate()
		reel_instance.reel_index = i
		add_child(reel_instance)
