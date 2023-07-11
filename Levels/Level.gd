extends Node2D
class_name Level

@onready var GV:Node = $"/root/GV";
@onready var game:Node2D = $"/root/Game";

@export var xmin = 0;
@export var xmax = 576;
@export var ymin = 0;
@export var ymax = 320;
var width:float;
var height:float;
var xmid:float;
var ymid:float;
var center:Vector2;


func _ready():
	width = xmax - xmin;
	height = ymax - ymin;
	xmid = (xmin + xmax)/2.0;
	ymid = (ymin + ymax)/2.0;
	center = Vector2(xmid, ymid);

#home and restart level changing
func _input(event):
	if event.is_action_pressed("home"):
		game.change_level_faded(0);
	elif event.is_action_pressed("restart"):
		game.change_level_faded(GV.current_level_index);
