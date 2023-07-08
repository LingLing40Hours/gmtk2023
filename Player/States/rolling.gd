extends State

func enter():
	actor.get_node("RollTurn").stop();
	actor.get_node("RollStraight").play();

func inPhysicsProcess(delta):
	#roll
	var direction = Input.get_axis("ui_left", "ui_right");
	actor.velocity += direction * actor.SPEED_ROLL * Vector2(cos(actor.rotation), sin(actor.rotation));
	
	#friction
	actor.velocity *= 1 - actor.MU_GROUND;
	
	#rolling anim speed
	actor.get_node("AnimatedSprite2D").speed_scale = actor.velocity.length() / 30;
	
	#roll anim direction
	if direction:
		actor.get_node("AnimatedSprite2D").speed_scale *= direction;
	
	actor.move_and_slide();
	
func changeParentState():
	if Input.is_action_pressed("fire_left") and actor.left_count:
		return states.shoot_left;
	if Input.is_action_pressed("fire_right") and actor.right_count:
		return states.shoot_right;
	if Input.get_axis("ui_left", "ui_right") and Input.is_action_pressed("arc"):
		return states.arcing;
	if actor.velocity.length() < actor.SPEED_MIN:
		return states.idle;
	return null;
