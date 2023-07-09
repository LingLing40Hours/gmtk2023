extends Gun

@export var round:PackedScene

@onready var sound:AudioStreamPlayer2D = $Machinegun;

var timerCount:int = 0
var bulletDirection:Vector2 = Vector2()

func _ready():
	DAMAGE = 16;
	SPEED = 980;
	BREAKWOOD_SPEED = 180;
	durability = 144;
	$FSM.setState($FSM.states.idle);

# very crude way of shooting
func shoot(direction: Vector2):
	timerCount = 0
	bulletDirection = direction
	$ShootTimer.start()

func _on_shoot_timer_timeout() -> void:
	var round1 = round.instantiate()     
	
	round1.bulletDirection(bulletDirection)
	
	get_parent().add_child(round1)
	
	round1.global_position = $Muzzle.global_position
	
	timerCount += 1
	
	if timerCount >= 3:
		$ShootTimer.stop()
