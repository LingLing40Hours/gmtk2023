extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
@export var initial_angle:float = 0;
const SPEED_ROLL = 20.0
const SPEED_YAW = 3;
const MU_GROUND:float = 0.1;

var gun:Gun = null;

func _ready():
	rotation_degrees = initial_angle;

func _physics_process(delta):
	#shooting
	if Input.is_action_just_pressed("fire") and gun != null:
		gun.fire();
		gun = null;
		game.change_ammo(GV.ammo - 1);
	
	#left/right movement
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		if Input.is_action_pressed("arc"): #yaw
			rotation_degrees += SPEED_YAW * direction;
		else: #roll
			velocity += direction * SPEED_ROLL * Vector2(cos(rotation), sin(rotation));

	#friction
	velocity *= 1 - MU_GROUND;

	move_and_slide()

func pickup(g:Node2D):
	game.change_ammo(GV.ammo+1);
	g.position -= position;
	g.get_parent().call_deferred("remove_child", g);
	call_deferred("add_child", g);
	gun = g;
