extends State

@onready var game:Node2D = $"/root/Game";


func inPhysicsProcess(delta):
	#friction
	actor.velocity *= 1 - actor.MU_AIR;
	
	#destroy everything in the way
	var collision = actor.move_and_collide(actor.velocity);
	if collision:
		var collider = collision.get_collider();
		if collider is TileMap:
			var pos = collider.local_to_map(collision.get_position() - collision.get_normal());
			var id = collider.get_cell_source_id(0, pos);
			if id == 1:
				game.add_score(GV.BREAKWOOD_SCORE);
				actor.get_node("BreakWood").play();
			collider.set_cell(0, pos, -1);
		else:
			collider.queue_free();

