extends CharacterBody2D


const H_SPEED = 300.0
const gravity = 200;

func _physics_process(delta):
	#gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	#roll
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
