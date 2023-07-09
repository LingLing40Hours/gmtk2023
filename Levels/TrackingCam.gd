extends Camera2D
class_name TrackingCam

@onready var game:Node2D = $"/root/Game";
@onready var player:CharacterBody2D = get_parent().get_node("Bullet");


func _ready():
	position = player.position;

func _process(_delta):
	position = player.position;
