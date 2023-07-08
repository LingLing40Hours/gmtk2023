extends Gun

@onready var game:Node2D = $"/root/Game";


func _ready():
	DAMAGE = 5;
	SPEED = 1200;
	$FSM.setState($FSM.states.idle);


func fire():
	change_state("fired");
	
	#enable collider
	$GunCollider.disabled = false;
	
	#find firing parameters
	var new_pos = position + get_parent().position;
	var new_rot_deg = get_parent().rotation_degrees;
	var dir = fire_dir();
	
	#change parent
	#get_parent().call_deferred("remove_child", self);
	#game.current_level.call_deferred("add_child", self);
	get_parent().remove_child(self);
	game.current_level.add_child(self);
	
	#set position, velocity, rotation
	position = new_pos;
	rotation_degrees = new_rot_deg;
	velocity += SPEED * dir;

func fire_dir() -> Vector2:
	if not get_parent().is_in_group("player"):
		return Vector2.ZERO;
	var angle = get_parent().rotation_degrees + 90;
	print("parent: ",angle);
	if left_loaded:
		angle += 180;
	print("self: ",angle);
	return Vector2(cos(angle), sin(angle));

func get_state() -> String:
	return $FSM.curState.name;

func change_state(s:String):
	$FSM.setState($FSM.states[s]);
