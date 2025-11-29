extends Node2D

@onready var cells = $Cells
@onready var cell_scene = preload("res://scenes/cell.tscn")

@onready var pieces = $Pieces
@onready var piece_scene = preload("res://scenes/piece.tscn")

var piece_size :Vector2 =Vector2(100,100)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.get_all_levels()
	Global.init_level(1)
	Global.level_complete.connect(next_level)
	init_game()

func next_level():
	Global.next_level()
	init_game()

func init_game():
	var color = 1.0 / (Global.levels.size())*(Global.current_level)
	RenderingServer.set_default_clear_color(Color(color,color,color,1))
	generate_pieces()
	draw_cells()

func draw_cells():
	for i in range(Global.grid_size.x):
		for j in range(Global.grid_size.y):
			add_cell(i,j)

func add_cell(i:int,j:int):
	var cell = cell_scene.instantiate()
	cells.add_child(cell)
	Global.cells.append(cell)
	cell.position = Vector2(piece_size.x*i,piece_size.y*j)
	var idx = int(j*Global.grid_size.x+i)
	cell.init_cell(idx, piece_size)

func generate_pieces():
	var image = Global.get_image()
	var texture = ImageTexture.create_from_image(image)
	piece_size = Vector2(texture.get_width()/Global.grid_size.x,texture.get_width()/Global.grid_size.y)
	for i in range(Global.grid_size.x):
		for j in range(Global.grid_size.y):
			var piece = piece_scene.instantiate()
			pieces.add_child(piece)
			Global.pieces.append(piece)
			var idx = int(j*Global.grid_size.x+i)
			var region = Rect2(i*piece_size.x,j*piece_size.y,piece_size.x,piece_size.y)
			var sub_image = image.get_region(Rect2i(region.position,region.size))
			var sub_text = ImageTexture.create_from_image(sub_image)
			var pos = Vector2(randi_range(100,600),randi_range(50,1000))
			piece.init_piece(idx, sub_text,pos,piece_size)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		Global.restart_level()
		init_game()
