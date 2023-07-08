extends State

var isTargetReached:bool = false
var isPlayerFound:bool = false

# Called when the parent enters the state
func enter():
	actor.playAnimation("run") 
	
	actor.setMovementTarget(actor.lastKnownPlayerPos)

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	isTargetReached = actor.moveToTargetPosition(delta)
	if isTargetReached:
		actor.pointPlayerSight()
		isPlayerFound = actor.isPlayerSpotted

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if isPlayerFound:
		return states.Chase
	if isTargetReached and not isPlayerFound:
		return states.Idle
	return null

func handleInput(event):
	pass

