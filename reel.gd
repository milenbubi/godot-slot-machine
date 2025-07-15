extends Control

@export var reel_index: int = 0
var reel_textures: Array[Control] = []

var spin_speed := 0.0  # pixels per second
var symbol_height := 0.0
var symbol_width := 0.0
var spinning := false
var spin_timer := 0.0
var reel_height := 0.0


func _ready():
	reel_height = get_parent().size.y
	symbol_height = get_parent().size.y / Constants.REEL_SYMBOLS_COUNT
	symbol_width = get_parent().size.x / Constants.TOTAL_REELS

	var total_pixels = Constants.SPIN_SPEED * Constants.SPIN_DURATION
	var closest_multiple = round(total_pixels / symbol_height) * symbol_height
	spin_speed = closest_multiple / Constants.SPIN_DURATION

	set_initial_reel_symbols()
	start_spin()


func start_spin():
	spinning = true
	spin_timer = 0.0


func stop_spin():
	spinning = false


func _process(delta):
	if spinning:
		spin_timer += delta
		var offset = spin_speed * delta
				
		if spin_timer >= Constants.SPIN_DURATION:
			var max_y = get_max_symbol_y()
			
			if max_y < reel_height:
				offset = reel_height - max_y

		for symbol in reel_textures:
			symbol.position.y += offset
		
		for symbol in reel_textures:
			# if the symbol goes out of the reel at the bottom, move it back to the top
			if symbol.position.y >= reel_height:
				# move it to the very top
				var min_y = get_min_symbol_y()
				symbol.position.y = min_y - symbol_height

				# change its texture
				var sprite = symbol.get_child(0) as Sprite2D
				sprite.texture = DiamondAssets.diamond_sprites[randi() % DiamondAssets.diamond_sprites.size()]

		if spin_timer >= Constants.SPIN_DURATION:
			stop_spin()

func get_min_symbol_y() -> float:
	var min_y = reel_textures[0].position.y
	for symbol in reel_textures:
		if symbol.position.y < min_y:
			min_y = symbol.position.y
	return min_y
	
func get_max_symbol_y() -> float:
	var max_y = reel_textures[0].position.y
	for el in reel_textures:
		if el.position.y > max_y:
			max_y = el.position.y
	return max_y	


func set_initial_reel_symbols():
	var parent_size = get_parent().size

	# Create REEL_SYMBOLS_COUNT + 2 for buffer
	for i in range(-2, Constants.REEL_SYMBOLS_COUNT):
		var container = create_symbol(i)  # Offset to create a buffer at the top
		add_child(container)
		reel_textures.append(container)


func create_symbol(index: int) -> Control:
	var parent_size = get_parent().size
	var random_texture = DiamondAssets.diamond_sprites[randi() % DiamondAssets.diamond_sprites.size()]

	var container = Control.new()
	container.size = Vector2(parent_size.x, symbol_height)
	container.position = Vector2(0, index * symbol_height)

	var sprite = Sprite2D.new()
	sprite.texture = random_texture

# Scale the sprite to fit its parent container
	var texture_height = sprite.texture.get_height()
	var texture_width = sprite.texture.get_width()
	var scale_factor_y = symbol_height / texture_height
	var scale_factor_x = symbol_width / texture_width

	sprite.scale = Vector2(scale_factor_x, scale_factor_y)
	sprite.position = Vector2(sprite.texture.get_width() * scale_factor_x / 2, sprite.texture.get_height() * scale_factor_y / 2)

	container.add_child(sprite)
	return container
