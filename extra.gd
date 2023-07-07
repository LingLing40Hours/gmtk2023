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
