extends Node

var TILE_WIDTH = 16;
var RESOLUTION = Vector2(576, 320);
var LEVEL_COUNT:int = 6;
var current_level_index:int = 0;
var current_level_score:int = 0;
var level_high_scores = [];

var TILE_HARDNESSES:Array[float] = [0.0015, 0.0028];
var BREAKWOOD_SCORE:int = 2;
var ammo:int = 0;

var rng = RandomNumberGenerator.new();


func _ready():
	level_high_scores.resize(LEVEL_COUNT);
	level_high_scores.fill(0);
	
	rng.randomize();
