extends State

func enter():
	actor.velocity = Vector2.ZERO;
	actor.get_node("RollStraight").stop()
	actor.get_node("RollTurn").stop()
	actor.get_node("AnimatedSprite2D").speed_scale = 0;
	
func changeParentState():
	if Input.is_action_pressed("fire_left") and actor.left_count:
		return states.shoot_left;
	if Input.is_action_pressed("fire_right") and actor.right_count:
		return states.shoot_right;
	if Input.get_axis("ui_left", "ui_right"):
		return states.arcing if Input.is_action_pressed("arc") else states.rolling;
	return null;
