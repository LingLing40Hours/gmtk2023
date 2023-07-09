extends State

var isAllowedToPatrol:bool = false

# Called when the parent enters the state
func enter():
	actor.playAnimation("idle") 
	
	$PatrolTimer.start()

# Called when parent leaves the state, most likely not necessary 
func exit():
	isAllowedToPatrol = false

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.isDead:
		return states.Dead
	if actor.isPlayerInRayCast and actor.isPLayerInVizCone:
		return states.Chase
	if not actor.isPlayerSpotted and isAllowedToPatrol:
		return states.Patrol
	return null

func handleInput(event):
	pass

func _on_timer_timeout() -> void:
	isAllowedToPatrol = true
