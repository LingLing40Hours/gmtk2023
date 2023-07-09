extends Gun

@onready var sound:AudioStreamPlayer2D = $Pistol;


func _ready():
	DAMAGE = 5;
	SPEED = 1200;
	BREAKWOOD_SPEED = 200;
	durability = 60;
	$FSM.setState($FSM.states.idle);

