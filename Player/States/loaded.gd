extends State

@onready var game:Node2D = $"/root/Game";


func enter():
	game.current_level.tracking_cam.tracking = false;
