extends Panel

@onready var digits_container = $DigitsContainer
var is_faded = false  # Track the current state


func _gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		is_faded = !is_faded
		for child in get_children():
			child.modulate.a = 0.2 if is_faded else 1.0

		
func clear_digits_container():
	for child in digits_container.get_children():
		digits_container.remove_child(child)
		child.queue_free()
		
		
		
# Displays a number by arranging digit sprites side-by-side
func show_number(value: int) -> void:
	is_faded = false
	self_modulate.a = 0.2
	clear_digits_container()  # Remove any previously displayed digits
	
	var index = 1	
	var size_y = get_parent().size.y / 2
	
	var currSprite = Sprite2D.new()
	currSprite.texture = load("res://assets/bmpfont/$.png")
	currSprite.position = Vector2(80 , size_y)
	currSprite.scale = Vector2(0.45, 0.45)
	digits_container.add_child(currSprite)
	
	var str_val = str(value)
	for i in range(str_val.length()):
		var digit_char = str_val[i]
			
		var digit = int(digit_char)
		var sprite = Sprite2D.new()
		
		# Load the texture for the digit, e.g. font_0.png, font_1.png, etc.
		var texture_path = "res://assets/bmpfont/" + str(digit) + ".png"
		sprite.texture = load(texture_path)
		sprite.position = Vector2(90 * (index + 1), size_y)
		sprite.scale = Vector2(0.6, 0.6)
		digits_container.add_child(sprite)
		index += 1

	var coin_scene = preload("res://scenes/Coin.tscn")
	var coin_anim = coin_scene.instantiate()
	coin_anim.position = Vector2(86 * (str_val.length() + 3) , size_y)
	coin_anim.scale = Vector2(0.76, 0.76)
	digits_container.add_child(coin_anim)
