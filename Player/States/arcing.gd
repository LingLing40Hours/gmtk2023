extends State

func enter():
	actor.get_node("RollStraight").stop();
	actor.get_node("RollTurn").play();

func inPhysicsProcess(delta):
	#arc
	var direction = Input.get_axis("ui_left", "ui_right");
	actor.rotation_degrees -= actor.SPEED_YAW * direction;
	
	#roll direction; right (angle left) when direction > 0
	actor.get_node("AnimatedSprite2D").speed_scale = 2.2 * direction;
	
	#friction
	actor.velocity *= 1 - actor.MU_GROUND;
	
	actor.move_and_slide();
	
func changeParentState():
	if Input.is_action_pressed("fire_left") and actor.left_count:
		return states.shoot_left;
	if Input.is_action_pressed("fire_right") and actor.right_count:
		return states.shoot_right;
	if not Input.is_action_pressed("arc"):
		if Input.get_axis("ui_left", "ui_right"):
			return states.rolling;
		return states.idle;
	return null;

