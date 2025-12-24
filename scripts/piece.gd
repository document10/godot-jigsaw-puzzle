extends Area2D

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@export var audioManager: Node
var dragging:bool = false
var drag_offset = Vector2.ZERO
var index = -1
var cell_index=-1

func init_piece(_index,texture,pos,piece_size):
	index=_index
	sprite2d.texture=texture
	position = pos
	collision.shape.set("size",piece_size)


func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if Global.dragging and dragging == false:
		return
	if cell_index == index:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			audioManager.play_sound("pickup")
			dragging=true
			if cell_index!=-1:
				var cell = Global.find_cell(cell_index)
				cell.occupy(false)
				cell_index=-1
			Global.dragging=true
			z_index=100
			drag_offset=global_position-Vector2(DisplayServer.mouse_get_position())
		elif event.is_released():
			dragging=false
			Global.dragging=false
			z_index=0;
			drop_piece()
			if Global.check_win()==true:
				print("VICTORY")

func drop_piece():
	var overlapping = get_overlapping_areas()
	for cell in overlapping:
		if cell.is_in_group("cells"):
				if cell.is_free():
					cell_index = cell.index
					position = cell.global_position
					cell.occupy(true)
					if cell_index==index:
						audioManager.play_sound("bonus")
						Global.add_score(5)
					else:
						audioManager.play_sound("drop")
					return
				else:
					audioManager.play_sound("drop")
					return

func _physics_process(delta: float) -> void:
	if dragging:
		position =  get_global_mouse_position() + drag_offset * delta
