extends CharacterBody2D


@export var pathErrorMargin:float = 5
@export var targetErrorMargin:float = 1
@export var movementSpeed:float = 5
@export var wallComfortDistance:int = 10
@export var patrolLength:int = 100
@export var playerTrackingLength:int = 100

var player

var health:float = 12;
var HARMFUL_SPEED:float = 100; #take damage if gun is faster than this

var isGunEquiped:bool = false
var isPlayerSpotted:bool = false
var hasPlayerBeenSeen:bool = false

var version

func _ready() -> void:
	$NavigationAgent2D.path_desired_distance = pathErrorMargin
	$NavigationAgent2D.target_desired_distance = targetErrorMargin
	
	$FrontVision.target_position = Vector2(wallComfortDistance, 0)
	$RearVision.target_position = Vector2(-wallComfortDistance, 0)
	$PlayerSight.target_position = Vector2(playerTrackingLength, 0)
	
	call_deferred("actorSetup")
	
func actorSetup() -> void:
	await get_tree().physics_frame

func _enter_tree() -> void:
	randomize()
	version = (randi() % 2 +1) # the soldier version will either be 1 or 2

func _physics_process(delta: float) -> void:
	pointPlayerSight()

func playAnimation(animationName: String) -> void:
	var animationAppendix = "_%d" % version
	$AnimatedSprite2D.play(animationName + animationAppendix)
	
func setMovementTarget(target: Vector2) -> void:
	$NavigationAgent2D.target_position = target

func setRelativeMovementTarget(target: Vector2) -> void:
	$NavigationAgent2D.target_position = global_position + target

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
	
	if velocity.x > 0:
		$AnimatedSprite2D.flip_h = false
		$VisionCone.scale.x = 1
	else:
		$AnimatedSprite2D.flip_h = true
		$VisionCone.scale.x = -1
		
	
	move_and_slide()
	
	return false

func pointPlayerSight() -> void:
	if hasPlayerBeenSeen:
		var playerDirection:Vector2 = player.global_position - global_position
		playerDirection = playerDirection.normalized()*playerTrackingLength
		$PlayerSight.target_position = playerDirection
	
	if $PlayerSight.is_colliding():
			var collisonObject:Node2D = $PlayerSight.get_collider()
			if collisonObject.is_in_group("player"):
				$Exclamation.show()
				isPlayerSpotted = true
			else:
				isPlayerSpotted = false
	else:
		isPlayerSpotted = false
	
	if !isPlayerSpotted:
		$Exclamation.hide()


func _on_vision_cone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player = body.get_node("AnimatedSprite2D")
		hasPlayerBeenSeen = true
		pointPlayerSight()
