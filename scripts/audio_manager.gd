extends Node

@onready var bonus_play = $Bonus
@onready var pickup_play = $Pickup
@onready var drop_play = $Drop
@onready var select_play = $Select

func play_sound(clip_name):
	match clip_name:
		"bonus":
			bonus_play.play()
		"pickup":
			pickup_play.play()
		"drop":
			drop_play.play()
		"select":
			select_play.play()	

# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#pass # Replace with function body.
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
	#pass
