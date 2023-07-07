extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
@export var initial_angle:float = 0;
const SPEED_ROLL = 20.0
const SPEED_YAW = 3;
const MU_GROUND:float = 0.1;
var SEP_STEP:float = 0.2; #separate guns slightly so they don't obstruct movement

var guns:Array[Gun];


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
				count += 1;
		game.change_ammo(GV.ammo - count);
	if Input.is_action_just_pressed("fire_right") and guns:
		var count = 0;
		for i in range(guns.size()-1, -1, -1):
			if not guns[i].left:
				guns[i].call_deferred("fire");
				guns.remove_at(i);
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

	var collision = move_and_collide(velocity * delta)
	if collision:
		var collider = collision.get_collider();
		if collider is Gun:
			collider.position += SEP_STEP * collider.fire_dir();
		else:
			velocity = velocity.slide(collision.get_normal())

func pickup(g:Node2D):
	g.position -= position;
	g.get_parent().remove_child(g);
	g.get_node("GunCollider").disabled = true;
	add_child(g);
	#g.get_parent().call_deferred("remove_child", g);
	#call_deferred("add_child", g);

func _on_left_body_entered(body):
	if body is Gun and body.state == body.States.IDLE:
		guns.append(body);
		game.change_ammo(GV.ammo+1);
		body.state = body.States.LOADED;
		call_deferred("pickup", body);
		
func _on_right_body_entered(body):
	if body is Gun and body.state == body.States.IDLE:
		guns.append(body);
		game.change_ammo(GV.ammo+1);
		body.state = body.States.LOADED;
		call_deferred("pickup", body);
