extends CharacterBody2D

<<<<<<< HEAD
@export var pathErrorMargin:float = 5
@export var targetErrorMargin:float = 1
@export var movementSpeed:float = 5

var HEALTH:float;
=======
var health:float = 12;
>>>>>>> main
var HARMFUL_SPEED:float = 100; #take damage if gun is faster than this

var version

func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = pathErrorMargin
	$NavigationAgent2D.target_desired_distance = targetErrorMargin
	
	call_deferred("actorSetup")
	
func actorSetup() -> void:
	await get_tree().physics_frame

func _enter_tree() -> void:
	randomize()
	version = (randi() % 2 +1) # the soldier version will either be 1 or 2
	
func playAnimation(animationName: String) -> void:
	var animationAppendix = "_%d" % version
	$AnimatedSprite2D.play(animationName + animationAppendix)
	
func setMovementTarget(target: Vector2) -> void:
	$NavigationAgent2D.target_position = target

# execute in physics process and returns if movement is complete 
func moveToTargetPosition(delta:float) -> bool:
	if $NavigationAgent2D.is_navigation_finished():
		return true
	
	var curPos:Vector2 = global_position
	var goalPos:Vector2 = $NavigationAgent2D.get_next_path_position()
	var velocityVector:Vector2 = goalPos - curPos
	
	velocityVector = velocityVector.normalized()
	velocityVector = velocityVector*movementSpeed
	
	velocity = velocityVector
	move_and_slide()
	
	return false
