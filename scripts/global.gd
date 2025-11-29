extends Node

var levels_path = "res://assets/levels.csv"

var cells  = []
var pieces = []
var grid_size = Vector2i(3,5)
var current_level=1

var dragging = false
var levels = []

signal level_complete

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

func next_level():
	if current_level<levels.size()-1:
		init_level(current_level+1)
	else:
		print("GAME COMPLETE")

func restart_level():
	init_level(current_level)

func get_image():
	var path = levels[current_level][1]
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
