extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
@export var initial_angle:float = 0;
const SPEED_ROLL = 20.0
const SPEED_YAW = 3;
const MU_GROUND:float = 0.1;

var guns_left:Array[Gun];
var guns_right:Array[Gun];


func _ready():
	rotation_degrees = initial_angle;

func _physics_process(delta):
	#shooting
	if Input.is_action_just_pressed("fire_left") and guns_left.size():
		for gun in guns_left:
			gun.fire();
		game.change_ammo(GV.ammo - guns_left.size());
		guns_left.clear();
	if Input.is_action_just_pressed("fire_right") and guns_right.size():
		for gun in guns_right:
			gun.fire();
		game.change_ammo(GV.ammo - guns_right.size());
		guns_right.clear();
	
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

func _on_loading_area_body_entered(body):
	if body.is_in_group("player") and not get_parent().is_in_group("player"):
		body.pickup(self);


func _on_left_body_entered(body):
	if body is Gun:
		pickup(body);
