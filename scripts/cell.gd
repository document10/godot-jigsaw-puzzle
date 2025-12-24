extends Area2D

@onready var sprite2d: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var offset = 5
var index = -1
var occupied = false

func init_cell(_index:int,piece_size:Vector2):
	index = _index
	sprite2d.texture.set("width",piece_size.x-offset/float(2))
	sprite2d.texture.set("height",piece_size.y-offset/float(2))
	collision.shape.set("size",Vector2(piece_size.x-offset,piece_size.y-offset))

func is_free():
	return not occupied

func occupy(val):
	occupied=val
