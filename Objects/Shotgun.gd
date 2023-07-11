extends Gun

@export var pellet:PackedScene

@onready var sound:AudioStreamPlayer2D = $Shotgun;

func _ready():
	DAMAGE = 9;
	SPEED = 840;
	BREAKWOOD_SPEED = 130;
	durability = 224;
	$FSM.setState($FSM.states.idle);

# very crude way of shooting
func shoot(direction: Vector2):
	var pellet1 = pellet.instantiate()
	var pellet2 = pellet.instantiate()
	var pellet3 = pellet.instantiate()
	
	pellet1.bulletDirection(direction)
	pellet2.bulletDirection(direction + Vector2(0.5, 0.5))
	pellet3.bulletDirection(direction + Vector2(-0.5, -0.5))
	
	curLevel.add_child(pellet1)
	curLevel.add_child(pellet2)
	curLevel.add_child(pellet3)
	
	pellet1.global_position = $Muzzle.global_position
	pellet2.global_position = $Muzzle.global_position + Vector2(0, 0.5)
	pellet3.global_position = $Muzzle.global_position + Vector2(0, -0.5)
	
