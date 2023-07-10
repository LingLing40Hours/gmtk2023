extends Gun

@export var round:PackedScene

@onready var sound:AudioStreamPlayer2D = $Pistol;


func _ready():
	DAMAGE = 4;
	SPEED = 1200;
	BREAKWOOD_SPEED = 280;
	durability = 66;
	$FSM.setState($FSM.states.idle);

# very crude way of shooting
func shoot(direction: Vector2):
	var round1 = round.instantiate()
	
	round1.bulletDirection(direction)
	
	get_parent().add_child(round1)
	
	round1.global_position = $Muzzle.global_position
