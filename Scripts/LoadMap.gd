extends Node3D

@onready var file = 'res://Maps/map1.txt'

var tile_width = 10
var tile_height = 10
var tile_scene

func _ready():
	tile_scene = preload("res://Prefabs/tile.tscn")
	load_file(file)

func load_file(file):
	var fileObj = FileAccess.open(file, FileAccess.READ)
	var content = fileObj.get_as_text()
	var width = 0
	var height = 0
	for ch in content:
		match ch:
			'T':
				addTile(width,height, "b_")
				width = width + 1
			'\n':
				height = height + 1
				width = 0
			_:
				width = width + 1
	return

#addsTile. width and height are integers. The conversion into world space is 
func addTile(width,height,type):
	var color
	var tile = tile_scene.instantiate()
	#set color base on checkerboard pattern
	tile.position = Vector3(width, 0, height)
	tile.init(type)
	add_child(tile)
#bathtubSpawn.set_position(spawner.get_position())
	var debugtemplate = "{0} {1},{2}".format({0:width, 1:height, 2:color})
	print(debugtemplate)
