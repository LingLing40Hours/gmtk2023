extends Gun

@onready var game:Node2D = $"/root/Game";
var DAMAGE:float = 5;
var SPEED:float = 1200;
var SPEED_MIN:float = 10;

var state = States.IDLE;
var left = true;


func _physics_process(delta):
	match state:
		States.IDLE:
			pass;
		States.LOADED:
			pass;
		States.FIRED:
			if velocity.length() < SPEED_MIN:
				velocity = Vector2.ZERO;
				state = States.IDLE;
			
			#friction
			velocity *= 1 - MU_AIR;
			
			#move
			var collision_info = move_and_collide(velocity * delta)
			if collision_info:
				var collider = collision_info.get_collider();
				if collider.is_in_group("enemy"):
					if not GV.rng.randi_range(0, 9): #soldier catches gun
						#code to give soldier the gun here
						queue_free();
					else: #damage and bounce off soldier
						if velocity.length() > collider.HARMFUL_SPEED:
							collider.health -= DAMAGE;
						velocity = velocity.bounce(collision_info.get_normal());
				else: #bounce off wall
					velocity = velocity.bounce(collision_info.get_normal());
				

func fire():
	state = States.FIRED;
	#find firing parameters
	var new_pos = position + get_parent().position;
	var new_rot_deg = get_parent().rotation_degrees;
	var dir = fire_dir();
	
	#change parent
	#get_parent().call_deferred("remove_child", self);
	#game.current_level.call_deferred("add_child", self);
	get_parent().remove_child(self);
	game.current_level.add_child(self);
	
	#set position, velocity, rotation
	position = new_pos;
	rotation_degrees = new_rot_deg;
	velocity += SPEED * dir;
	state = States.IDLE;
	
	print(velocity);

func fire_dir() -> Vector2:
	if not get_parent().is_in_group("player"):
		return Vector2.ZERO;
	var angle = get_parent().rotation_degrees;
	if left:
		angle += 180;
	return Vector2(cos(angle), sin(angle));
