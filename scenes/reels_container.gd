extends Panel

@onready var spin_button = $SpinButton
@onready var reel_container = $Reels
var reels: Array = []
var win_lines: Array[Array] = []
var reels_stopped = 0



func _ready():
	init_empty_wins()
	
	for reel in reel_container.get_children():
		reels.append(reel)
		reel.connect("spin_finished", Callable(self, "_on_reel_spin_finished"))
	
	spin_button.pressed.connect(_on_spin_button_pressed)


func init_empty_wins():
	win_lines=[]
	for i in range(Constants.REEL_SYMBOLS_COUNT):
		var row = []
		for j in range(Constants.TOTAL_REELS):
			row.append(null)
		win_lines.append(row)


func _on_spin_button_pressed():
	spin_button.disabled = true
	spin_button.modulate.a = 0.7
	reels_stopped = 0
	
	if self.has_node("WinDisplay"):
		var wins_display = self.get_node("WinDisplay")
		remove_child(wins_display)
		wins_display.queue_free()
	
	init_empty_wins()
	for reel in reels:
		reel.start_spin()


func _on_reel_spin_finished(data: Dictionary):
	reels_stopped += 1
	var names = data["names"]
	var reel_index = data["reel_index"]	
	
	for i in range(Constants.REEL_SYMBOLS_COUNT): 
		win_lines[i][reel_index]=names[i]
		
	if reels_stopped >= reels.size():
		spin_button.disabled = false
		spin_button.modulate.a = 1
		showWins()		
		
		

		
		
func showWins():
	var results = []  # will hold all found winning lines

	for row_index in range(win_lines.size()):
		var row = win_lines[row_index]
		var current_symbol = row[0]
		var streak = 1  # how many consecutive matches we have

		for col in range(1, row.size()):
			if row[col] == current_symbol and current_symbol != null:
				streak += 1
			else:
				# check if the streak is sufficient
				if streak >= 3:
					results.append({
						"symbol": current_symbol,
						"count": streak,
						"row": row_index
					})
				# restart streak
				current_symbol = row[col]
				streak = 1

		# check for streak at the end of the row
		if streak >= 3:
			results.append({
				"symbol": current_symbol,
				"count": streak,
				"row": row_index
			})

	var total_win = 0
	for item in results:
		total_win += item["count"] * 100
	
	print()
	print("Win Lines: ", results)
	print("Total win: ", total_win)	
	
	if total_win == 0:
		return
	
	var win_display = preload("res://scenes/win_display.tscn").instantiate()
	add_child(win_display)

	var wins_container = win_display.get_node("WinContainer")
	wins_container.show_number(total_win)
	
