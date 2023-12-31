class_name Gun
extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
enum States {IDLE, LOADED, FIRED, SOLIDIFIED};

var MU_AIR:float = 0.01;
var DAMAGE:float;
var SPEED:float;
var SPEED_MIN:float = 28;
var BREAKWOOD_SPEED:float;
var BREAKWOOD_SLOWDOWN:float = 40;

var durability:float;
var left_loaded:bool;

var curLevel:Level

func _enter_tree() -> void:
	curLevel = $"/root/Game".current_level

#calls to this function must be deferred (bc of drop())
func fire():
	print("FIRE");
	if get_state() == "firing":
		#add firing velocity
		velocity += SPEED * fire_dir();
		#detach from player
		get_parent().drop(self, false, "fired");

	
#when calling, parent must be player, otherwise returns (0, 0)
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
