extends State

@onready var game:Node2D = $"/root/Game";


func enter():
	game.current_level.get_node("Camera2D").tracking = false;
