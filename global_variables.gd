extends Node

const TILE_WIDTH = 16;
const RESOLUTION = Vector2(576, 320);
const TILE_RESOLUTION = RESOLUTION/TILE_WIDTH;

const LEVEL_COUNT:int = 6;
var current_level_index:int = 0;
var current_level_score:int = 0;
var level_high_scores = [];
var level_stone_broken = []

const TILE_HARDNESSES:Array[float] = [0.0015, 0.0028];
const BREAKWOOD_SCORE:int = 1;
const LOADTANK_SCORE:int = 50;
const SOLDIER_SCORE:int = 6;
var ammo:int = 0;

const FIRST_LEVEL_ROW = 3;
const BULLET_SPEED_HS = 32;
const BULLET_SPEED_REG = 14.4;

var rng = RandomNumberGenerator.new();


func _ready():
	level_high_scores.resize(LEVEL_COUNT);
	level_high_scores.fill(0);
	level_stone_broken.resize(LEVEL_COUNT);
	level_stone_broken.fill(false);
	
	rng.randomize();
