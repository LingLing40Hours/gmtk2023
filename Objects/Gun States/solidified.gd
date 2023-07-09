extends State
	
@onready var GV:Node = $"/root/GV";
@onready var game:Node2D = $"/root/Game";


func enter():
	actor.get_node("GunCollider").disabled = false;
	
func inPhysicsProcess(delta):
	#friction
	actor.velocity *= 1 - actor.MU_AIR;
	
	#move
	var collision_info = actor.move_and_collide(actor.velocity * delta);
	if collision_info:
		var speed = actor.velocity.length();
		var collider = collision_info.get_collider();
		if collider.is_in_group("enemy"):
			if not GV.rng.randi_range(0, 9): #soldier catches gun
				#code to give soldier the gun here
				actor.queue_free();
			else: #damage and bounce off soldier
				if speed > collider.HARMFUL_SPEED:
					collider.health -= actor.DAMAGE;
				actor.velocity = actor.velocity.bounce(collision_info.get_normal());
				actor.durability -= speed * collider.HARDNESS;
		elif collider is TileMap:
			var pos = collider.local_to_map(collision_info.get_position() - collision_info.get_normal());
			var id = collider.get_cell_source_id(0, pos);
			actor.durability -= speed * GV.TILE_HARDNESSES[id];
			if id == 0:
				actor.velocity = actor.velocity.bounce(collision_info.get_normal());
				actor.get_node("Stone").play();
			else:
				if speed > actor.BREAKWOOD_SPEED:
					collider.set_cell(0, pos, -1);
					actor.velocity *= 1 - actor.BREAKWOOD_SLOWDOWN/speed;
					game.add_score(GV.BREAKWOOD_SCORE);
					actor.get_node("BreakWood").play();
				else:
					actor.velocity = actor.velocity.bounce(collision_info.get_normal());
					actor.get_node("Wood").play();
		else: #bounce off wall
			actor.velocity = actor.velocity.bounce(collision_info.get_normal());
	#break
	if actor.durability <= 0:
		actor.queue_free();
	
func changeParentState():
	if actor.velocity.length() < actor.SPEED_MIN:
		return states.idle;
	return null;
