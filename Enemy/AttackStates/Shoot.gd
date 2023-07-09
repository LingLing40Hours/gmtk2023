extends State

# Called when the parent enters the state
func enter():
	print("shooting")
	pass 

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	if actor.hasPlayerBeenSeen and actor.isGunEquiped:
		actor.equipedGun.look_at(actor.player.global_position)

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	if actor.get_node("FSM").curState != actor.get_node("FSM").states.Chase:
		return states.Idle
	return null

func handleInput(event):
	pass

