extends Node2D

@onready var cells :Node2D = $Cells
@onready var cell_scene = preload("res://scenes/cell.tscn")

@onready var pieces :Node2D = $Pieces
@onready var piece_scene = preload("res://scenes/piece.tscn")

@onready var gameui :Control = $GameUI
@onready var elapsed :Label= $GameUI/Elapsed

@onready var mainMenu :Control = $MainMenu

@onready var audioManager = $AudioManager

var piece_size :Vector2 =Vector2(100,100)
var last_level_finished = false
var custom_level = []
var timer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#RenderingServer.set_default_clear_color(Color.GREEN)
	Global.get_all_levels()
	Global.level_complete.connect(level_complete)
	Global.end_game.connect(game_complete)
	last_level_finished=false

func level_complete():
	if Global.current_level!=-1:
		Global.next_level()
		if not last_level_finished:
			init_game()
		else:
			mainMenu.show()
			gameui.hide()
	else:
		mainMenu.show()
		gameui.hide()
		
func game_complete():
	last_level_finished=true

func init_custom_level(difficulty):
	last_level_finished=false
	timer=0
	gameui.show()
	custom_level=Global.generate_random_level(difficulty)
	Global.load_custom_level(custom_level)
	RenderingServer.set_default_clear_color(custom_level[4])
	generate_pieces()
	draw_cells()

func restart_custom_level():
	last_level_finished=false
	timer=0
	Global.load_custom_level(custom_level)
	RenderingServer.set_default_clear_color(custom_level[4])
	generate_pieces()
	draw_cells()

func init_game():
	last_level_finished=false
	var color = 1.0 / (Global.levels.size())*(Global.current_level)
	RenderingServer.set_default_clear_color(Color(1-color,1-color,color,1))
	timer=0
	generate_pieces()
	draw_cells()
	gameui.show()

func draw_cells():
	for i in range(Global.grid_size.x):
		for j in range(Global.grid_size.y):
			add_cell(i,j)

func add_cell(i:int,j:int):
	var cell = cell_scene.instantiate()
	cells.add_child(cell)
	Global.cells.append(cell)
	cell.position = Vector2(i,j)*piece_size
	var idx = int(j*Global.grid_size.x+i)
	cell.init_cell(idx, piece_size)

func generate_pieces():
	var image = Global.get_image()
	var texture = ImageTexture.create_from_image(image)
	piece_size = Vector2(texture.get_width()/float(Global.grid_size.x),texture.get_width()/float(Global.grid_size.y))
	Global.generate_matrix()
	var k = 0
	for i in range(Global.grid_size.x):
		for j in range(Global.grid_size.y):
			var piece = piece_scene.instantiate()
			pieces.add_child(piece)
			Global.pieces.append(piece)
			var idx = int(j*Global.grid_size.x+i)
			var region = Rect2(i*piece_size.x,j*piece_size.y,piece_size.x,piece_size.y)
			var sub_image = image.get_region(Rect2i(region.position,region.size))
			var sub_text = ImageTexture.create_from_image(sub_image)
			var loc = Global.find_position(k)
			var pos = Vector2((loc.x-Global.grid_size.x)*piece_size.x-piece_size.x/2,loc.y*piece_size.y)
			piece.audioManager=audioManager
			piece.init_piece(idx, sub_text,pos,piece_size)
			k+=1

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if mainMenu.visible:
			mainMenu.hide()
			gameui.show()
		else:
			mainMenu.show()
			gameui.hide()
			
	if event.is_action_pressed("restart"):
		Global.restart_level()
		if Global.current_level!=-1:
			init_game()
		else:
			restart_custom_level();


func _on_button_pressed() -> void:
	Global.init_level(1)
	init_game()
	mainMenu.hide()


func _on_easy_game_pressed() -> void:
	init_custom_level(1)
	mainMenu.hide()


func _on_medium_game_pressed() -> void:
	init_custom_level(2)
	mainMenu.hide()


func _on_hard_game_pressed() -> void:
	init_custom_level(3)
	mainMenu.hide()


func _on_random_game_pressed() -> void:
	init_custom_level(4)
	mainMenu.hide()

func _physics_process(delta: float) -> void:
	Global.red_score(delta)
	timer+=delta
	elapsed.text="Time:"+str(roundi(timer))+"\nScore:"+str(roundi(Global.score))
