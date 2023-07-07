extends Node

var LEVEL_COUNT:int = 6;
var current_level_index:int = 0;
var level_scores = [];

var TILE_WIDTH:float = 40; #px

var rng = RandomNumberGenerator.new();


func _ready():
	level_scores.resize(LEVEL_COUNT);
	level_scores.fill(0);
	
	rng.randomize();
