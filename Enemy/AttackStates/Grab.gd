extends State

# Called when the parent enters the state
func enter():
	actor.grabing.show()
	actor.grabing.play("default") 
	$GrabTimer.start()

# Called when parent leaves the state, most likely not necessary 
func exit():
	actor.grabing.hide()
	$GrabTimer.stop()

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

func _on_grab_timer_timeout() -> void:
	pass # Replace with function body.
