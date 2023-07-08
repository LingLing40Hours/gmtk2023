extends Gun

@onready var game:Node2D = $"/root/Game";


func _ready():
	DAMAGE = 5;
	SPEED = 1200;
	$FSM.setState($FSM.states.idle);


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
