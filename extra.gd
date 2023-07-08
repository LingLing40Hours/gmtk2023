extends Node

'''
var SEP_STEP:float = 0.2; #separate guns slightly so they don't obstruct movement
			'''

'''
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider();
		if collider is Gun:
			collider.position += SEP_STEP * collider.fire_dir();
		else:
			velocity = velocity.slide(collision.get_normal())
'''

'''
	#in pickup():
	#g.position -= position;
	#var pos_angle = atan2(g.position.y, g.position.x) - rotation;
	#g.position = g.position.length() * Vector2(cos(pos_angle), sin(pos_angle));
	
	#g.get_parent().call_deferred("remove_child", g);
	#call_deferred("add_child", g);
	
	#in fire():
	#get_parent().call_deferred("remove_child", self);
	#game.current_level.call_deferred("add_child", self);

	var dpos = position + get_parent().position;
	#var new_rot_rad = get_parent().rotation;
	var new_pos_rot_rad = atan2(dpos.y, dpos.x) + get_parent().rotation;
	var new_pos = dpos.length() * Vector2(cos(new_pos_rot_rad), sin(new_pos_rot_rad));
	var dir = fire_dir();
'''
