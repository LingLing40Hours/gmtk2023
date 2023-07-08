extends State

var isTargetReached = false
var isMovingForward = true
# Called when the parent enters the state
func enter():
	var frontRayCast:RayCast2D = actor.get_node("FrontVision")
	var rearRayCast:RayCast2D = actor.get_node("RearVision")
	
	if frontRayCast.is_colliding():
		var distance:Vector2 = frontRayCast.get_collision_point() - actor.global_position
		if abs(distance.length()) < actor.wallComfortDistance and isMovingForward:
			isMovingForward = false
	
	if rearRayCast.is_colliding():
		var distance:Vector2 = rearRayCast.get_collision_point() - actor.global_position
		if abs(distance.length()) < actor.wallComfortDistance and !isMovingForward:
			isMovingForward = true
	
	if isMovingForward:
		actor.setRelativeMovementTarget(Vector2(50, 0))
	else:
		actor.setRelativeMovementTarget(Vector2(-50, 0))
		
	actor.playAnimation("run")

# Called when parent leaves the state
func exit():
	isTargetReached = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	isTargetReached = actor.moveToTargetPosition(delta)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if isTargetReached:
		return states.Idle
	return null

func handleInput(event):
	pass

