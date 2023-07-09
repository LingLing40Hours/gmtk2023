extends Level

var buttons = [];
var selected_level = 0;
const BUTTON_CHAR_WIDTH:int = 27;
const SCORE_CHAR_WIDTH:int = 3;


func _ready():
	for i in range(1, GV.LEVEL_COUNT):
		#get buttons
		var button = get_node("GUI/VBoxContainer/HBoxContainer/VBoxContainer/Button" + str(i));
		buttons.push_back(button);
		
		#update score display
		change_high_score(i, GV.level_high_scores[i]);
	
		#update right wall stones
		if GV.level_stone_broken[i]:
			$TileMap.set_cell(0, Vector2i(GV.TILE_RESOLUTION.x - 1, GV.FIRST_LEVEL_ROW + 2*(i-1)), -1);


func _input(event):
	if event.is_action_pressed("home"):
		pass;
	elif event.is_action_pressed("restart"):
		pass;

func _on_texture_button_pressed():
	if selected_level:
		game.change_level_faded(selected_level);

func change_high_score(level, score):
	GV.level_high_scores[level] = score;
	
	#update display
	var s:String = "Level " + str(level);
	for i in range(BUTTON_CHAR_WIDTH - 19 - digit_count(score)):
		s += " ";
	s += "High Score: " + str(score);
	buttons[level-1].text = s;

func digit_count(n):
	var ans = 1;
	while n >= 10:
		n /= 10;
		ans += 1;
	return ans;

func _on_button_pressed():
	selected_level = 1;


func _on_button_2_pressed():
	selected_level = 2;


func _on_button_3_pressed():
	selected_level = 3;


func _on_button_4_pressed():
	selected_level = 4;


func _on_button_5_pressed():
	selected_level = 5;
