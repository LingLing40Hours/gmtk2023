extends Camera2D
class_name TrackingCam

@onready var game:Node2D = $"/root/Game";
@onready var level:Node2D = get_parent();
@onready var player:CharacterBody2D = level.get_node("Bullet");

@export var max_rx:float = 0.41; #ratio between x offset and level width at which camera moves
@export var max_ry:float = 0.34;

var tween;
var target:Vector2;
var transitioned = true;
var TRANSITION_TIME = 1.28;
var pmin:Vector2;
var pmax:Vector2;


func _ready():
	pmin = Vector2(level.xmin + GV.RESOLUTION.x/2, level.ymin + GV.RESOLUTION.y/2);
	pmax = Vector2(level.xmax - GV.RESOLUTION.x/2, level.ymax - GV.RESOLUTION.y/2);
	position = player.position.clamp(pmin, pmax);
	

func _process(_delta):
	var dx = abs(player.position.x - position.x);
	var dy = abs(player.position.y - position.y);
	if transitioned and (dx/GV.RESOLUTION.x >= max_rx or dy/GV.RESOLUTION.y >= max_ry):
		tween = create_tween();
		tween.set_ease(Tween.EASE_OUT);
		tween.finished.connect(_on_tween_transitioned);
		tween.set_process_mode(Tween.TWEEN_PROCESS_IDLE);
		
		target = player.position.clamp(pmin, pmax);
		tween.tween_property(self, "position", target, TRANSITION_TIME).set_trans(Tween.TRANS_QUINT);
		
	#position = player.position;

func _on_tween_transitioned():
	transitioned = true;
