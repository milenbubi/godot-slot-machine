extends TextureButton

@onready var spin_sound = $SpinButtonMusicPlayer


func _on_pressed() -> void:
	spin_sound.play()
