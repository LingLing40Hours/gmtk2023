extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";
@export var initial_angle:float = 0;
const SPEED_ROLL = 15.0
const SPEED_YAW = 3;
const MU_GROUND:float = 0.1;
const SPEED_MIN = 10;


var guns:Array[Gun];
var gun_colliders:Array[CollisionPolygon2D];
var left_count = 0;
var right_count = 0;

@export var health:float = 20

func _ready():
	rotation_degrees = initial_angle;
	change_state("idle");


func pickup(g:Node2D):
	print("PICKUP");	
	#steal gun from level
	var dpos = g.position - position;
	var l = dpos.length();
	var r = dpos.angle() - rotation;
	g.position = l * Vector2(cos(r), sin(r));
	g.rotation -= rotation;
	
	#steal collider from gun
	var col_shape = g.get_node("GunCollider");
	var temp_col_shape = col_shape.duplicate();
	col_shape.disabled = true;
	temp_col_shape.position = g.position;
	temp_col_shape.rotation = g.rotation;
	
	#add gun
	g.get_parent().remove_child(g);
	add_child(g);
	guns.append(g);

	#add collider
	add_child(temp_col_shape);
	gun_colliders.append(temp_col_shape);
	
	#update ammo
	game.change_ammo(GV.ammo+1);


#calls to this function must be deferred, ex.
#bullet.call_deferred("transfer", self, gun);
func transfer(soldier:CharacterBody2D, gun:CharacterBody2D):
	print("TRANSFER");
	#convert gun transform
	var sb = position - soldier.position;
	var bg_l = gun.position.length();
	var bg_a = gun.position.angle() + rotation;
	var bg = bg_l * Vector2(cos(bg_a), sin(bg_a));
	gun.position = sb + bg;
	gun.rotation += rotation;
	
	#duplicate collider to soldier
	var collider = gun.get_node("GunCollider");
	var new_collider = collider.duplicate();
	collider.disabled = true;
	new_collider.position = gun.position;
	new_collider.rotation = gun.rotation;
	
	#change parent
	var index = guns.rfind(gun);
	
	remove_child(gun);
	guns.remove_at(index);
	
	remove_child(gun_colliders[index]);
	gun_colliders.remove_at(index);
	
	soldier.add_child(gun);
	
	#update ammo
	game.change_ammo(GV.ammo - 1);

func reduceHealth(damage:float):
	health -= damage
	if health <= 0:
		pass # put death code here

func _on_left_body_entered(body):
	if body is Gun and body.get_state() == "idle":
		body.change_state("loaded");
		body.left_loaded = true;
		left_count += 1;
		call_deferred("pickup", body);
		
func _on_right_body_entered(body):
	if body is Gun and body.get_state() == "idle":
		body.change_state("loaded");
		body.left_loaded = false;
		right_count += 1;
		call_deferred("pickup", body);



func _on_animated_sprite_2d_animation_finished():
	match $AnimatedSprite2D.animation:
		"shoot_left":
			for i in range(guns.size()-1, -1, -1):
				if guns[i].left_loaded:
					guns[i].call_deferred("fire");
					guns.remove_at(i);
					call_deferred("remove_child", gun_colliders[i]);
					gun_colliders.remove_at(i);
			game.change_ammo(GV.ammo - left_count);
			left_count = 0;
			$AnimatedSprite2D.stop();
			$AnimatedSprite2D.play("roll");
		"shoot_right":
			for i in range(guns.size()-1, -1, -1):
				if not guns[i].left_loaded:
					guns[i].call_deferred("fire");
					guns.remove_at(i);
					call_deferred("remove_child", gun_colliders[i]);
					gun_colliders.remove_at(i);
			game.change_ammo(GV.ammo - right_count);
			right_count = 0;
			$AnimatedSprite2D.stop();
			$AnimatedSprite2D.play("roll");

func get_state() -> String:
	return $FSM.curState.name;

func change_state(s:String):
	$FSM.setState($FSM.states[s]);


func _on_roll_straight_finished():
	if get_state() == "rolling":
		$RollStraight.play();

func _on_roll_turn_finished():
	if get_state() == "arcing":
		$RollTurn.play();
