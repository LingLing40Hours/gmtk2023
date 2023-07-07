extends Node2D

@onready var GV:Node = $"/root/GV";
@onready var game:Node2D = $"/root/Game";


func _input(event):
	if event.is_action_pressed("home"):
		#game.change_level_faded(0);
		pass;
	elif event.is_action_pressed("restart"):
		#game.change_level_faded(GV.current_level_index);
		pass;


func _on_texture_button_pressed():
	game.change_level_faded(1);
