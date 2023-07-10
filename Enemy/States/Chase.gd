extends State

var isTargetReached:bool = false
var playerPos:Vector2 = Vector2()

# Called when the parent enters the state
func enter():
	actor.playAnimation("run")
	actor.exclamation.show()
	actor.isChasingPlayer = true

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.lastKnownPlayerPos = playerPos
	actor.exclamation.hide()
	actor.isChasingPlayer = false
	

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	playerPos = actor.player.global_position
	actor.setMovementTarget(playerPos)
	isTargetReached = actor.moveToTargetPosition(delta)
#	print(actor.isPlayerInRayCast)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.isDead:
		return states.Dead
	if not actor.isPlayerInRayCast:
		return states.Search
	return null

func handleInput(event):
	pass

