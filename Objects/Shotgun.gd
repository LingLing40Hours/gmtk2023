extends Gun

@onready var sound:AudioStreamPlayer2D = $Shotgun;


func _ready():
	DAMAGE = 9;
	SPEED = 500;
	BREAKWOOD_SPEED = 100;
	durability = 180;
	$FSM.setState($FSM.states.idle);

