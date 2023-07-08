extends Node2D
class_name Level

@onready var GV:Node = $"/root/GV";
@onready var game:Node2D = $"/root/Game";

@export var xmin = 0;
@export var xmax = 576;
@export var ymin = 0;
@export var ymax = 320;


#home and restart level changing
func _input(event):
	if event.is_action_pressed("home"):
		game.change_level_faded(0);
	elif event.is_action_pressed("restart"):
		game.change_level_faded(GV.current_level_index);
