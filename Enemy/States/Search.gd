extends State

var isTargetReached:bool = false
var isPlayerFound:bool = false

# Called when the parent enters the state
func enter():
	actor.playAnimation("run") 
	actor.confusion.show()
	actor.setMovementTarget(actor.lastKnownPlayerPos)

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.confusion.hide()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	isTargetReached = actor.moveToTargetPosition(delta)
	if isTargetReached:
		actor.pointPlayerSight()

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.isPlayerInRayCast or actor.isPLayerInVizCone:
		return states.Chase
	if isTargetReached and not isPlayerFound:
		return states.Idle
	return null

func handleInput(event):
	pass

