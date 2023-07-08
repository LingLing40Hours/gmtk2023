extends Node

var LEVEL_COUNT:int = 6;
var current_level_index:int = 0;
var level_scores = [];

var TILE_HARDNESSES:Array[float] = [0.0015, 0.0028];
var BREAKWOOD_SCORE:int = 2;
var ammo:int = 0;

var rng = RandomNumberGenerator.new();


func _ready():
	level_scores.resize(LEVEL_COUNT);
	level_scores.fill(0);
	
	rng.randomize();
