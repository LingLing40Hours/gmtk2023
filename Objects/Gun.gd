class_name Gun
extends CharacterBody2D

enum States {IDLE, LOADED, FIRED, SOLIDIFIED};

var MU_AIR:float = 0.01;
var DAMAGE:float;
var SPEED:float;
var SPEED_MIN:float = 10;

var left_loaded:bool;
