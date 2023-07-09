extends Node2D

@onready var GV:Node = $"/root/GV";
@onready var current_level:Node2D;
@onready var fader:AnimationPlayer = $AnimationPlayer;
@onready var display:HBoxContainer = $"GUI/HBoxContainer";
@onready var ammo_label:Label = $"GUI/HBoxContainer/VBoxContainer/AmmoLabel";
@onready var score_label:Label = $"GUI/HBoxContainer/VBoxContainer/ScoreLabel";

signal level_changed;
var levels = [];
var next_level_index:int;

var player;


func _ready():
	#bullet
	player = load("res://Player/Bullet.tscn");
	
	#levels
	for i in range(GV.LEVEL_COUNT):
		levels.append(load("res://Levels/Level"+str(i)+".tscn"));
	add_level(GV.current_level_index);
	
	#initialize display text
	change_ammo(GV.ammo);
	add_score(0);

#defer this until previous level has been freed
func add_level(n):
	var level:Node2D = levels[n].instantiate();
	add_child(level);
	current_level = level;
	
	#fade in music
	if current_level.has_node("BGM"):
		var bgm = current_level.get_node("BGM");
		bgm.fade_in();
		bgm.play();
	
	emit_signal("level_changed");

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
	
	#fade out
	fader.play("fade_in_black");
	if current_level.has_node("BGM"):
		current_level.get_node("BGM").fade_out();

#passed level, update high score
func let_bullet_fly(from_level, hs):
	#update high score
	if hs:
		GV.level_high_scores[from_level] = GV.current_level_score;
	
	#change level (update high score before lv0 ready)
	change_level_faded(0);
	await level_changed;
	
	#break level stone
	GV.level_stone_broken[from_level] = true;
	
	#stick into wall if new high score, else bounce off
	var bullet = player.instantiate();
	current_level.add_child(bullet);
	bullet.rotation = -PI/2;
	bullet.position = Vector2(GV.RESOLUTION.x, GV.TILE_WIDTH*(GV.FIRST_LEVEL_ROW + 2*from_level - 1.5));
	if hs:
		bullet.high_scored = true;
		bullet.velocity = Vector2(-GV.BULLET_SPEED_HS, 0);
	else:
		bullet.high_scored = false;
		bullet.velocity = Vector2(-GV.BULLET_SPEED_REG, 0);
	bullet.change_state("flying");
	

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
	
