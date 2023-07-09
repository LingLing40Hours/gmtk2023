extends State

@onready var game:Node2D = $"/root/Game";


func inPhysicsProcess(delta):
	#friction
	actor.velocity *= 1 - actor.MU_AIR;
	
	var collision = actor.move_and_collide(actor.velocity);
	if collision:
		var collider = collision.get_collider();
		if collider is TileMap:
			var pos = collider.local_to_map(collision.get_position() - collision.get_normal());
			var id = collider.get_cell_source_id(0, pos);
			if id == 1:
				var bw = actor.get_node("BreakWood").duplicate();
				actor.add_child(bw);
				bw.play();
			collider.set_cell(0, pos, -1);
		elif collider.is_in_group("milestone"):
			if actor.high_scored: #dig into wall
				collider.get_node("AnimatedSprite2D").play("shot");
				collider.get_node("Impact").play();
				collider.get_node("Crumble").play();
				actor.queue_free();
			else: #bounce and increase friction
				actor.velocity = actor.velocity.bounce(collision.get_normal());
				print("BOUNCED", actor.position);
		else:
			collider.queue_free();

	#delete
	if actor.velocity.length() < actor.SPEED_MIN:
		actor.queue_free();
		print("FREED", actor.position);
