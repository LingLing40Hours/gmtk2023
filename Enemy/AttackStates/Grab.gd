extends State

var hasAttemptedGrab:bool = false

# Called when the parent enters the state
func enter():
	actor.grabing.show()
	actor.grabing.play("default") 
	$GrabTimer.start()
#	print("grab attack")

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.grabing.hide()
	$GrabTimer.stop()

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
#	hasAttemptedGrab = false
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.get_node("FSM").curState == actor.get_node("FSM").states.Chase and actor.isGunEquiped:
		return states.Shoot
	if hasAttemptedGrab or !actor.isPlayerInGrabRange or !actor.isGunInGrabRange:
		return states.Idle
	return null

func handleInput(event):
	pass

func _on_grab_timer_timeout() -> void:
	hasAttemptedGrab = true
	actor.grabAttack()

