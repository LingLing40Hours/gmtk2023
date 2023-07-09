extends CharacterBody2D

@export var speed:float = 15
@export var damage:float = 1

var direction:Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	bulletDirection(Vector2(0, -1))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	var motion = direction.normalized()*speed
	var collidedWith:KinematicCollision2D = move_and_collide(motion)
	if collidedWith != null:
		if collidedWith.get_collider().has_method("reduceHealth"):
			collidedWith.get_collider().reduceHealth(damage)
		queue_free()

func bulletDirection(_direction: Vector2) -> void:
	direction = _direction
