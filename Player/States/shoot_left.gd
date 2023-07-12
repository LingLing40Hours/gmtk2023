extends State

func enter():
	actor.get_node("Buildup").play();
	actor.get_node("AnimatedSprite2D").speed_scale = 1;
	actor.get_node("AnimatedSprite2D").play("shoot_left");

func inPhysicsProcess(delta): #allow movement
	#arc/roll
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		if Input.is_action_pressed("arc"):
			actor.rotation_degrees -= actor.SPEED_YAW * direction;
		else:
			actor.velocity += direction * actor.SPEED_ROLL * Vector2(cos(actor.rotation), sin(actor.rotation));
	
	#friction
	actor.velocity *= 1 - actor.MU_GROUND;
	
	actor.move_and_slide();
	
func changeParentState():
	if actor.left_count:
		return null;
	if Input.is_action_pressed("fire_right"):
		return states.shoot_right;
	if Input.get_axis("ui_left", "ui_right"):
		return states.arcing if Input.is_action_pressed("arc") else states.rolling;
	if actor.velocity.length() < actor.SPEED_MIN:
		return states.idle;

