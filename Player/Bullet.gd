extends CharacterBody2D

@onready var game:Node2D = $"/root/Game";

const SPEED_ROLL = 15.0
const SPEED_YAW = 2.2;
const MU_GROUND:float = 0.1;
const MU_AIR:float = 0.005;
const SPEED_MIN = 10;


var guns:Array[Gun];
var gun_colliders:Array[CollisionPolygon2D];
var left_count = 0;
var right_count = 0;


@export var health:float = 20
var high_scored = false; #determines bullet behavior when returning to lv0


func _ready():
	change_state("idle");

func _input(event):
	if event.is_action_pressed("drop_left"):
		for i in range(guns.size()):
			if guns[i].left_loaded:
				call_deferred("drop", i, true, "idle");
	elif event.is_action_pressed("drop_right"):
		for i in range(guns.size()):
			if not guns[i].left_loaded:
				call_deferred("drop", i, true, "idle");

#calls to this function must be deferred
#transforms gun coordinates, and
#transfers ownership from self to current level
func drop(gun_index, enable_collider, new_gun_state):
	var gun = guns[gun_index];
	
	#convert gun transform to global
	var br = gun.position.angle() + rotation;
	gun.position = position + gun.position.length() * Vector2(cos(br), sin(br));
	gun.rotation += rotation;
	
	#remove gun
	remove_child(gun);
	guns.remove_at(gun_index);
	remove_child(gun_colliders[gun_index]);
	gun_colliders.remove_at(gun_index);
	gun.index = -1;
	
	#add gun to current level
	if enable_collider:
		gun.get_node("GunCollider").disabled = false;
	gun.change_state(new_gun_state);
	game.current_level.add_child(gun);

#calls to this function must be deferred
func pickup(g:Node2D):
	#print("PICKUP");	
	#steal gun from level
	var dpos = g.position - position;
	var l = dpos.length();
	var r = dpos.angle() - rotation;
	g.position = l * Vector2(cos(r), sin(r));
	g.rotation -= rotation;
	
	#steal collider from gun
	var col_shape = g.get_node("GunCollider");
	var temp_col_shape = col_shape.duplicate();
	temp_col_shape.position = g.position;
	temp_col_shape.rotation = g.rotation;
	temp_col_shape.scale = g.scale;
	
	#remove gun from level
	col_shape.disabled = true;
	g.get_parent().remove_child(g);
	
	#add gun
	g.index = guns.size();
	guns.append(g);
	add_child(g);

	#add collider
	gun_colliders.append(temp_col_shape);
	add_child(temp_col_shape);
	
	#update ammo
	game.change_ammo(GV.ammo+1);


#calls to this function must be deferred, ex.
#bullet.call_deferred("transfer", self, gun);
func transfer(soldier:CharacterBody2D, gun:CharacterBody2D):
	#print("TRANSFER");
	#convert gun transform
	var sb = position - soldier.position;
	var bg_l = gun.position.length();
	var bg_a = gun.position.angle() + rotation;
	var bg = bg_l * Vector2(cos(bg_a), sin(bg_a));
	gun.position = sb + bg;
	gun.rotation += rotation;
	
	#duplicate and transform collider
	var collider = gun.get_node("GunCollider");
	var new_collider = collider.duplicate();
	collider.disabled = true;
	new_collider.position = gun.position;
	new_collider.rotation = gun.rotation;
	new_collider.scale = gun.scale;
	
	#remove gun
	remove_child(gun);
	guns.remove_at(gun.index);
	remove_child(gun_colliders[gun.index]);
	gun_colliders.remove_at(gun.index);
	gun.index = -1;
	
	#add gun to soldier
	soldier.add_child(gun);
	soldier.add_child(new_collider);
	
	#update ammo
	game.change_ammo(GV.ammo - 1);

func reduceHealth(damage:float):
	health -= damage
	if health <= 0:
		pass # put death code here

func _on_left_body_entered(body):
	if Input.is_action_pressed("drop_left"):
		return;
	if body is Gun and body.get_state() == "idle":
		body.change_state("loaded");
		body.left_loaded = true;
		left_count += 1;
		call_deferred("pickup", body);
		
func _on_right_body_entered(body):
	if Input.is_action_pressed("drop_right"):
		return;
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
			game.change_ammo(GV.ammo - left_count);
			left_count = 0;
			$AnimatedSprite2D.stop();
			$AnimatedSprite2D.play("roll");
		"shoot_right":
			for i in range(guns.size()-1, -1, -1):
				if not guns[i].left_loaded:
					guns[i].call_deferred("fire");
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
