extends Node
var diamond_sprites: Array[Texture2D] = []


func _ready():
	load_assets()  #Load assets

func load_assets():
	if diamond_sprites.size() > 0:
		return # already loaded

	var dir = DirAccess.open("res://assets/")
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".png") and file_name.begins_with("SC_Symbols_"):
				var texture = load("res://assets/" + file_name)
				diamond_sprites.append(texture)
				print("✅ Asset Loaded: ", file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
