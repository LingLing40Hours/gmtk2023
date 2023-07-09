extends Gun

@onready var sound:AudioStreamPlayer2D = $Machinegun;


func _ready():
	DAMAGE = 16;
	SPEED = 660;
	BREAKWOOD_SPEED = 280;
	durability = 140;
	$FSM.setState($FSM.states.idle);
