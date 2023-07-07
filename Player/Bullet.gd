extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
@export var initial_angle:float = 0;
const SPEED_ROLL = 20.0
const SPEED_YAW = 3;
const MU_GROUND:float = 0.1;


var guns:Array[Gun];
var gun_colliders:Array[CollisionPolygon2D];


func _ready():
	rotation_degrees = initial_angle;

func _physics_process(delta):
	#shooting
	if Input.is_action_just_pressed("fire_left") and guns:
		var count = 0;
		for i in range(guns.size()-1, -1, -1):
			if guns[i].left:
				guns[i].call_deferred("fire");
				guns.remove_at(i);
				call_deferred("remove_child", gun_colliders[i]);
				gun_colliders.remove_at(i);
				count += 1;
		game.change_ammo(GV.ammo - count);
	if Input.is_action_just_pressed("fire_right") and guns:
		var count = 0;
		for i in range(guns.size()-1, -1, -1):
			if not guns[i].left:
				guns[i].call_deferred("fire");
				guns.remove_at(i);
				call_deferred("remove_child", gun_colliders[i]);
				gun_colliders.remove_at(i);
				count += 1;
		game.change_ammo(GV.ammo - count);
	
	#left/right movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if Input.is_action_pressed("arc"): #yaw
			rotation_degrees += SPEED_YAW * direction;
		else: #roll
			velocity += direction * SPEED_ROLL * Vector2(cos(rotation), sin(rotation));

	#friction
	velocity *= 1 - MU_GROUND;

	move_and_slide();

func pickup(g:Node2D):
	print("PICKUP");
	#steal collider from gun
	var col_shape = g.get_node("GunCollider");
	var temp_col_shape = col_shape.duplicate();
	col_shape.disabled = true;
	temp_col_shape.position = g.position - position;
	add_child(temp_col_shape);
	gun_colliders.append(temp_col_shape);
	
	#steal gun from level
	g.position -= position;
	g.get_parent().remove_child(g);
	add_child(g);
	guns.append(g);
	#g.get_parent().call_deferred("remove_child", g);
	#call_deferred("add_child", g);
	
	#update ammo
	game.change_ammo(GV.ammo+1);

func _on_left_body_entered(body):
	if body is Gun and body.state == body.States.IDLE:
		body.state = body.States.LOADED;
		body.left = true;
		call_deferred("pickup", body);
		
func _on_right_body_entered(body):
	if body is Gun and body.state == body.States.IDLE:
		body.state = body.States.LOADED;
		body.left = false;
		call_deferred("pickup", body);
