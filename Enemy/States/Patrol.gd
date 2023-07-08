extends State

var frontRayCast:RayCast2D
var rearRayCast:RayCast2D

var isTargetReached = false
var isMovingForward = true
# Called when the parent enters the state
func enter():
	frontRayCast = actor.get_node("FrontVision")
	rearRayCast = actor.get_node("RearVision")
	
	if frontRayCast.is_colliding() and isMovingForward:
		isMovingForward = false
		actor.setRelativeMovementTarget(Vector2(-actor.patrolLength, 0))
	if rearRayCast.is_colliding() and !isMovingForward:
		isMovingForward = true
		actor.setRelativeMovementTarget(Vector2(actor.patrolLength, 0))
	
	if isMovingForward:
		actor.setRelativeMovementTarget(Vector2(actor.patrolLength, 0))
	else:
		actor.setRelativeMovementTarget(Vector2(-actor.patrolLength, 0))
		
	actor.playAnimation("run")

# Called when parent leaves the state
func exit():
	isTargetReached = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	if frontRayCast.is_colliding() and isMovingForward:
		isMovingForward = false
		actor.setRelativeMovementTarget(Vector2(0, 0))
	if rearRayCast.is_colliding() and !isMovingForward:
		isMovingForward = true
		actor.setRelativeMovementTarget(Vector2(0, 0))
	
	isTargetReached = actor.moveToTargetPosition(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.isPlayerSpotted:
		return states.Chase
	if isTargetReached:
		return states.Idle
	return null

func handleInput(event):
	pass

