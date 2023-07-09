extends CharacterBody2D


@export var pathErrorMargin:float = 5
@export var targetErrorMargin:float = 1
@export var movementSpeed:float = 40
@export var wallComfortDistance:int = 10
@export var patrolLength:int = 250
@export var playerTrackingLength:int = 105

@onready var exclamation:Sprite2D = $Exclamation
@onready var confusion:Sprite2D = $Confusion
@onready var grabing:AnimatedSprite2D = $Grabing

var player:Node2D
var lastKnownPlayerPos:Vector2 = Vector2()
var equipedGun:Gun = null

var health:float = 12;
var HARDNESS:float = 0.001; #reduces gun durability
var HARMFUL_SPEED:float = 100; #take damage if gun is faster than this

var isGunEquiped:bool = false
var isPlayerSpotted:bool = false
var isPlayerInRayCast:bool = false
var isPLayerInVizCone:bool = false
var hasPlayerBeenSeen:bool = false
var isPlayerInGrabRange:bool = false
var isGunInGrabRange:bool = false
var isDead:bool = false

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

# execute in physics process and returns true if movement is complete 
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
		$Grabing.scale.x = 0.5
		$Grabing.position.x = 12
	else:
		$AnimatedSprite2D.flip_h = true
		$VisionCone.scale.x = -1
		$Grabing.scale.x = -0.5
		$Grabing.position.x = -12
	
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
				isPlayerInRayCast = true
			else:
				isPlayerInRayCast = false
	else:
		isPlayerInRayCast = false

func grabAttack() -> void:
	var gunList:Array[Gun] = player.get_parent().guns

	if isGunInGrabRange and not gunList.is_empty():
		var closeGun:Gun = null
		var prevDistance = 1000000000000
		for gun in gunList:
			var distance = (gun.global_position - global_position).length_squared()
			if distance < prevDistance:
				prevDistance = distance
				closeGun = gun
		player.get_parent().call_deferred("transfer", self, closeGun)
		equipedGun = closeGun
		isGunEquiped = true
	if gunList.is_empty() and isPlayerInGrabRange:
		player.get_parent().change_state("grabbed")
		player.get_parent().call_deferred("transfer", self, player)

func reduceHealth(damage:float) -> void:
	health -= damage
	if health <= 0:
		isDead = true

func _on_vision_cone_body_entered(body: Node2D) -> void:
#	print(body)
	if body.is_in_group("player"):
		player = body.get_node("AnimatedSprite2D")
		hasPlayerBeenSeen = true
		isPLayerInVizCone = true
		pointPlayerSight()

func _on_vision_cone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		isPLayerInVizCone = false

func _on_grabbing_range_body_entered(body: Node2D) -> void:
#	print(body)
	if body.is_in_group("player"):
		isPlayerInGrabRange = true
		if not body.guns.is_empty():
			isGunInGrabRange = true
#		print(body)

func _on_grabbing_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
#		print(body)
		isPlayerInGrabRange = false
		isGunInGrabRange = false
