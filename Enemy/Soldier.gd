extends CharacterBody2D

var HEALTH:float;
var HARMFUL_SPEED:float = 100; #take damage if gun is faster than this

var version

func _enter_tree() -> void:
	randomize()
	version = (randi() % 2 +1) # the version will either be 1 or 2
	
func playAnimation(animationName: String):
	var animationAppendix = "_%d" % version
	$AnimatedSprite2D.play(animationName + animationAppendix)
	
