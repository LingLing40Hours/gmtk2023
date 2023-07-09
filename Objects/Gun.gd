class_name Gun
extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
enum States {IDLE, LOADED, FIRED, SOLIDIFIED};

var MU_AIR:float = 0.01;
var DAMAGE:float;
var SPEED:float;
var SPEED_MIN:float = 24;
var BREAKWOOD_SPEED:float;
var BREAKWOOD_SLOWDOWN:float = 40;

var durability:float;
var left_loaded:bool;

func fire():
	change_state("fired");
	
	#set firing velocity
	velocity += SPEED * fire_dir();
	
	#convert to global transform
	var br = get_parent().rotation + 90;
	position = get_parent().position + position.length() * Vector2(cos(br), sin(br));
	rotation += br - 90;
	
	#change parent
	get_parent().remove_child(self);
	game.current_level.add_child(self);
	

func fire_dir() -> Vector2:
	if not get_parent().is_in_group("player"):
		return Vector2.ZERO;
	var angle = get_parent().rotation_degrees;
	if left_loaded:
		angle += 180;
	angle = deg_to_rad(angle);
	return Vector2(cos(angle), sin(angle));

func get_state() -> String:
	return $FSM.curState.name;

func change_state(s:String):
	$FSM.setState($FSM.states[s]);
	
func shoot(direction: Vector2):
	pass
