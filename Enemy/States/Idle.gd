extends State

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the parent enters the state
func enter():
	actor.playAnimation("idle") 

# Called when parent leaves the state, most likely not necessary 
func exit():
	pass

# Called every physics frame. 'delta' is the elapsed time since the previous frame. Run in FSM _physics_process.
func inPhysicsProcess(delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame. Run in FSM _process.
func inProcess(delta):
	pass

func changeParentState():
	return null

func handleInput(event):
	pass

