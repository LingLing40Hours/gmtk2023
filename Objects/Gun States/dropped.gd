extends State

var tick_count = 4;
var ticks;


func enter():
	ticks = 0;

func inPhysicsProcess(delta):
	ticks += 1;

func changeParentState():
	if ticks == tick_count:
		return states.solidified;
	return null;
