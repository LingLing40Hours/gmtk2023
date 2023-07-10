extends Camera2D
class_name TrackingCam

@onready var game:Node2D = $"/root/Game";
@onready var level:Node2D = get_parent();
@onready var player:CharacterBody2D = level.get_node("Bullet");

@export var max_rx:float = 0.41; #ratio between x offset and level width at which camera moves
@export var max_ry:float = 0.34;

var tracking:bool = true;
var max_dx:float;
var max_dy:float;

var tween;
var target:Vector2;
var transitioned = true;
var TRANSITION_TIME = 1.28;
var pmin:Vector2;
var pmax:Vector2;


func _ready():
	#find max coord offsets from center of screen
	max_dx = max_rx * GV.RESOLUTION.x;
	max_dy = max_ry * GV.RESOLUTION.y;
	
	#find position limits
	pmin = Vector2(level.xmin + GV.RESOLUTION.x/2, level.ymin + GV.RESOLUTION.y/2);
	pmax = Vector2(level.xmax - GV.RESOLUTION.x/2, level.ymax - GV.RESOLUTION.y/2);
	
	#set initial position
	position = player.position.clamp(pmin, pmax);
	

func _process(_delta):
	if tracking and transitioned:
		#figure out whether to move
		var dx = player.position.x - position.x;
		var dy = player.position.y - position.y;
		if	(dx >= max_dx and position.x != pmax.x) or \
			(dx <= -max_dx and position.x != pmin.x) or \
			(dy >= max_dy and position.y != pmax.y) or \
			(dy <= -max_dy and position.y != pmin.y):

			#slide to current player pos
			tween = create_tween();
			tween.set_ease(Tween.EASE_OUT);
			tween.finished.connect(_on_tween_transitioned);
			tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE);
			
			target = player.position.clamp(pmin, pmax);
			tween.tween_property(self, "position", target, TRANSITION_TIME).set_trans(Tween.TRANS_QUINT);
		
	#position = player.position;

func _on_tween_transitioned():
	transitioned = true;
