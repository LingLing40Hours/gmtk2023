extends TileMap

@export var tileSizedNavigationRegion:PackedScene = preload("res://Levels/tile_navigation_region.tscn")

@onready var level:Level = get_parent()
@onready var navRegion:NavigationRegion2D = get_parent().get_node("NavigationRegion2D")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
#	print(level)
#	print(navRegion)
#	print(get_used_cells(0))
#	print(get_cell_tile_data(0, Vector2i(0,0)).)
#	erase_cell(0, Vector2i(1,0))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func updateNavRegion(tilePos: Vector2i) -> void:
#	var newNavRegion:NavigationRegion2D = NavigationRegion2D.new()
#	newNavRegion.name = "test"
#	var navPoly:NavigationPolygon = NavigationPolygon.new()
#	level.add_child(newNavRegion)
#	print(level.get_children())
	var newNavRegion:NavigationRegion2D = tileSizedNavigationRegion.instantiate()
	newNavRegion.position = tilePos*16
	print(newNavRegion)
	level.add_child(newNavRegion)
