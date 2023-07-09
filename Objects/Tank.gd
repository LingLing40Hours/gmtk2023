extends StaticBody2D

@onready var game:Node2D = $"/root/Game";

const LOAD_TIME = 3.6;
const FLY_TIME = 3.4;
const BULLET_DPOS:Vector2 = Vector2(-80, -1);
const MUZZLE_VELOCITY_HS = 1500;
const MUZZLE_VELOCITY_REG = 900;
var timer;
var player;


func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and body.get_state() != "loaded":
		player = body;
		player.change_state("loaded");
		player.get_node("Fader").play("fade_out");
		
		#load bullet
		var reload_index = GV.rng.randi_range(0, $Reloads.get_child_count()-1);
		$Reloads.get_child(reload_index).play();
		
		#wait for loading to finish
		timer = get_tree().create_timer(LOAD_TIME);
		await timer.timeout;
		
		#fire bullet
		player.get_node("Fader").stop();
		player.modulate.a = 1;
		player.rotation = -PI/2;
		
		var shot_index = GV.rng.randi_range(0, $Shots.get_child_count()-1);
		$Shots.get_child(shot_index).play();
		player.position = position + BULLET_DPOS;
		var hs = true if GV.current_level_score > GV.level_high_scores[GV.current_level_index] else false;
		if hs:
			player.velocity = Vector2(-MUZZLE_VELOCITY_HS, 0);
		else:
			player.velocity = Vector2(-MUZZLE_VELOCITY_REG, 0);
		player.change_state("fired");
		
		#let bullet fly
		timer = get_tree().create_timer(FLY_TIME);
		await timer.timeout;
		
		#return to homescreen
		game.let_bullet_fly(GV.current_level_index, hs);
	
