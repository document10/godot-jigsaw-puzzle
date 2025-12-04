extends Node

var levels_path = "res://assets/levels.csv"

var all_textures = ["res://assets/im1.jpg","res://assets/im2.jpg","res://assets/im3.jpg","res://assets/im4.jpg","res://assets/im5.jpg","res://assets/im6.jpg","res://assets/im7.jpg"]
var cells  = []
var pieces = []
var grid_size = Vector2i(3,5)
var current_level=1
var custom_image=""
var custom_level = []
var dragging = false
var levels = []

signal level_complete
signal end_game

func get_all_levels():
	var file = FileAccess.open(levels_path,FileAccess.READ)
	var content = file.get_as_text()
	var level_lines = content.split('\n')
	level_lines.remove_at(level_lines.size()-1)
	for line in level_lines:
		levels.append(line.split(','))			

func init_level(level:int):
	current_level=level
	grid_size = Vector2i(int(levels[current_level][2]),int(levels[current_level][3]))
	if not cells.is_empty():
		for cell in cells:
			cell.queue_free()
	cells = []
	if not pieces.is_empty():
		for piece in pieces:
			piece.queue_free()
	pieces = []

func load_custom_level(level:Array):
	custom_level=level
	current_level=-1
	grid_size = Vector2i(level[2],level[3])
	custom_image = level[1]
	if not cells.is_empty():
		for cell in cells:
			cell.queue_free()
	cells = []
	if not pieces.is_empty():
		for piece in pieces:
			piece.queue_free()
	pieces = []

func next_level():
	if current_level<levels.size()-1:
		init_level(current_level+1)
	else:
		end_game.emit()

func restart_level():
	if(current_level!=-1):
		init_level(current_level)
	else:
		load_custom_level(custom_level)

func get_image():
	var path = ""
	if current_level == -1:
		path = custom_level[1]
	else:	
		path = levels[current_level][1]
	var res = load(path)
	var txt = ImageTexture.create_from_image(res)
	return txt.get_image()
	
	
func find_cell(index:int):
	for cell in cells:
		if cell.index ==index:
			return cell

func check_win():
	for piece in pieces:
		if piece.index !=piece.cell_index:
			return false
	level_complete.emit()
	return true	
	
func last_level()->bool:
	return current_level==levels.size()-1
	
func generate_random_level(difficulty:int)->Array:
	match difficulty:
		1:
			return [1,all_textures.pick_random(),randi_range(2,3),randi_range(2,3),Color.CORNFLOWER_BLUE]
		2:
			return [2,all_textures.pick_random(),randi_range(3,4),randi_range(3,4),Color.LIME]
		3:
			return [3,all_textures.pick_random(),randi_range(3,5),randi_range(3,5),Color.MAGENTA]
		4:
			return [4,all_textures.pick_random(),randi_range(2,5),randi_range(2,5),Color.INDIGO]
		_:
			return []
