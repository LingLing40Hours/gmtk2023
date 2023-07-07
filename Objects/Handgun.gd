extends Gun

@onready var game:Node2D = $"/root/Game";
var DAMAGE:float = 5;
var SPEED:float = 1200;

func _physics_process(delta):
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
				collider.health -= DAMAGE;
				velocity = velocity.bounce(collision_info.get_normal());
		else: #bounce off wall
			velocity = velocity.bounce(collision_info.get_normal());

	
func _on_loading_area_body_entered(body):
	if body.is_in_group("player") and not get_parent().is_in_group("player"):
		body.pickup(self);

func fire():
	#change parent
	position += get_parent().position;
	get_parent().call_deferred("remove_child", self);
	game.current_level.call_deferred("add_child", self);
	
	#set speed and dir
	var angle = get_parent().rotation_degrees - 90;
	var dir = Vector2(cos(angle), sin(angle));
	velocity += SPEED * dir;
