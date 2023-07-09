extends AudioStreamPlayer2D

var tween;


func fade_in():
	tween = create_tween();
	tween.tween_property(self, "volume_db", 0, 0.5);

func fade_out():
	tween = create_tween();
	tween.tween_property(self, "volume_db", -80, 0.5);
