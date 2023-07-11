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


''' bullet
func _physics_process(delta):
	if $AnimatedSprite2D.animation == "roll":
		#rolling anim speed
		$AnimatedSprite2D.speed_scale = velocity.length() / 30;
		
		#shooting
		if Input.is_action_just_pressed("fire_left") and left_count:
			$AnimatedSprite2D.speed_scale = 1;
			$AnimatedSprite2D.play("shoot_left");
		if Input.is_action_just_pressed("fire_right") and right_count:
			$AnimatedSprite2D.speed_scale = 1;
			$AnimatedSprite2D.play("shoot_right");
	
	#left/right movement
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		if Input.is_action_pressed("arc"): #yaw
			rotation_degrees -= SPEED_YAW * direction;
			
			#roll direction; right (angle left) when direction > 0
			$AnimatedSprite2D.speed_scale = 2.2 * direction;
		else: #roll
			velocity += direction * SPEED_ROLL * Vector2(cos(rotation), sin(rotation));
			
			#roll direction
			if direction:
				$AnimatedSprite2D.speed_scale *= direction;

	#friction
	velocity *= 1 - MU_GROUND;

	move_and_slide();
'''

''' in gun states/fired.gd
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
		else: #bounce
			actor.velocity = actor.velocity.bounce(collision_info.get_normal());
			
	#break
	if actor.durability <= 0:
		actor.queue_free();
'''

'''on bullet's shoot animation finished
					guns.remove_at(i);
					call_deferred("remove_child", gun_colliders[i]);
					gun_colliders.remove_at(i);
'''

'''
func fire():
	change_state("fired");
	
	#set firing velocity
	velocity += SPEED * fire_dir();
	
	#convert to global transform
	var br = get_parent().rotation + 90;
	position = get_parent().position + position.length() * Vector2(cos(br), sin(br));
	rotation += br - 90;
	
	#change parent
	get_parent().remove_child(self);
	game.current_level.add_child(self);
'''
