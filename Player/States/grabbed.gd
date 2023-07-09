extends State

func enter():
	actor.reduceHealth(actor.health)
	pass;

func changeParentState():
	return null;
