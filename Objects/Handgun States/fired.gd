extends State

var TICK_TOTAL = 4;
var ticks:int;

func enter():
	ticks = 0;
	

func inPhysicsProcess(delta):
	#friction, stopping
	actor.velocity *= 1 - actor.MU_AIR;
	if actor.velocity.length() < actor.SPEED_MIN:
		actor.velocity = Vector2.ZERO;
	
	#move
	var collision_info = actor.move_and_collide(actor.velocity * delta)
	if collision_info:
		var collider = collision_info.get_collider();
		if collider.is_in_group("enemy"):
			if not GV.rng.randi_range(0, 9): #soldier catches gun
				#code to give soldier the gun here
				actor.queue_free();
			else: #damage and bounce off soldier
				if actor.velocity.length() > collider.HARMFUL_SPEED:
					collider.health -= actor.DAMAGE;
				actor.velocity = actor.velocity.bounce(collision_info.get_normal());
		else: #bounce off wall
			actor.velocity = actor.velocity.bounce(collision_info.get_normal());
			
	ticks += 1;
	
func changeParentState():
	if actor.velocity == Vector2.ZERO:
		return states.idle;
	elif ticks > TICK_TOTAL:
		return states.solidified;
	return null;
