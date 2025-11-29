extends Camera2D

var dir:Vector2 = Vector2.ZERO
@export var speed:float = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	dir = Vector2.ZERO
	if event.is_action_pressed("move_up"):
		dir.y=-1
	if event.is_action_pressed("move_down"):
		dir.y=1
	if event.is_action_pressed("move_left"):
		dir.x=-1
	if event.is_action_pressed("move_right"):
		dir.x=1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position+= dir*delta*speed
