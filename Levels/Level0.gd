extends Level


func _input(event):
	if event.is_action_pressed("home"):
		pass;
	elif event.is_action_pressed("restart"):
		pass;


func _on_texture_button_pressed():
	game.change_level_faded(1);
