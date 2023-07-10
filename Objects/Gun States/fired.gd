extends State

@onready var GV:Node = $"/root/GV";
@onready var game:Node2D = $"/root/Game";

var TICK_TOTAL = 1;
var ticks:int;


func enter():
	ticks = 0;
	actor.sound.play();

func inPhysicsProcess(delta):
	#friction
	actor.velocity *= 1 - actor.MU_AIR;
	
	#move
	var collision_info = actor.move_and_collide(actor.velocity * delta)
	#won't collide since collider is disabled
	
	ticks += 1;
	
func changeParentState():
	if actor.velocity.length() < actor.SPEED_MIN:
		return states.idle;
	elif ticks > TICK_TOTAL:
		return states.solidified;
	return null;
