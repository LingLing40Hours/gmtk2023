extends Node2D

@onready var GV:Node = $"/root/GV";
@onready var current_level:Node2D;
@onready var fader:AnimationPlayer = $"GUI/AnimationPlayer";
@onready var display:HBoxContainer = $"GUI/ColorRect/HBoxContainer";
@onready var ammo_label:Label = $"GUI/ColorRect/HBoxContainer/VBoxContainer/AmmoLabel";
@onready var score_label:Label = $"GUI/ColorRect/HBoxContainer/VBoxContainer/ScoreLabel";
var levels = [];
var next_level_index:int;
var player;
const FIRST_LEVEL_ROW = 3;
const BULLET_SPEED_HS = 1200;
const BULLET_SPEED_REG = 720;


func _ready():
	#bullet
	player = load("res://Player/Bullet.tscn");
	
	#levels
	for i in range(GV.LEVEL_COUNT):
		levels.append(load("res://Levels/Level"+str(i)+".tscn"));
	add_level(GV.current_level_index);
	
	#gui
	change_ammo(GV.ammo);
	add_score(0);

#defer this until previous level has been freed
func add_level(n):
	var level:Node2D = levels[n].instantiate();
	add_child(level);
	current_level = level;

#update current level and current level index
func change_level(n):
	if (n >= GV.LEVEL_COUNT):
		return;
	current_level.queue_free();
	GV.current_level_score = 0;
	
	call_deferred("add_level", n);
	GV.current_level_index = n;
	
	#display
	change_ammo(0);
	add_score(0);
	display.visible = true if n else false;

func change_level_faded(n):
	if (n >= GV.LEVEL_COUNT):
		return;
	next_level_index = n;
	fader.play("fade_in_black");

#passed level, update high score
func let_bullet_fly(from_level, hs):
	#change level
	change_level_faded(0);
	await current_level.ready;
	
	#stick into wall if new high score, else bounce off
	var bullet = player.instantiate();
	bullet.rotation = -PI/2;
	bullet.position = Vector2(GV.RESOLUTION.x, GV.TILE_WIDTH*(FIRST_LEVEL_ROW+0.5));
	if hs:
		bullet.high_scored = true;
		bullet.velocity = Vector2(-BULLET_SPEED_HS, 0);
		GV.level_high_scores[from_level] = GV.current_level_score;
	else:
		bullet.high_scored = false;
		bullet.velocity = Vector2(-BULLET_SPEED_REG, 0);
	bullet.change_state("flying");
	add_child(bullet);
	

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in_black":
		change_level(next_level_index);
		fader.play("fade_out_black");


#GUI STUFF
func change_ammo(n):
	GV.ammo = n;
	ammo_label.text = "Ammo: " + str(n);

func add_score(n):
	GV.current_level_score += n;
	score_label.text = "Score: " + str(GV.current_level_score);
	
