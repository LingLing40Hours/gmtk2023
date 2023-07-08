extends State
	

func enter():
	actor.get_node("GunCollider").disabled = false;
	
func inPhysicsProcess(delta):
	#friction, stopping
	actor.velocity *= 1 - actor.MU_AIR;
	if actor.velocity.length() < actor.SPEED_MIN:
		actor.velocity = Vector2.ZERO;
	
	#move
	var collision_info = actor.move_and_collide(actor.velocity * delta);
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
		elif collider is TileMap:
			var pos = collider.local_to_map(collision_info.get_position() - collision_info.get_normal());
			var id = collider.get_cell_source_id(0, pos);
			if id == 0:
				actor.velocity = actor.velocity.bounce(collision_info.get_normal());
			elif actor.velocity.length() > actor.BREAKWOOD_SPEED:
				collider.set_cell(0, pos, -1);
		else: #bounce off wall
			actor.velocity = actor.velocity.bounce(collision_info.get_normal());
	
func changeParentState():
	if actor.velocity == Vector2.ZERO:
		return states.idle;
	return null;
