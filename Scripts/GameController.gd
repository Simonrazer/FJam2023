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
	var content:String = fileObj.get_as_text()
	var width = 0
	var height = 0
	
	var lines = content.split('\n')
	var Map_Width = lines[0].length()
	var Map_height = content.count("\n")
	
	var TileMatrix=[]
	for x in range(Map_Width):
		TileMatrix.append([])
		#glaube das braucht man nicht aber you never know
		for y in range(Map_height):
			TileMatrix[x].append(0)
	for ch in content:
		# eigene Charactere:
		#T = Tile
		#B = Brute
		#H = Bloohound
		#M = Mage
		#R = Rook
		# gegnerische Charactere:
		#m = Minion
		#h = Hound
		#s = Soldier
		#a = Archer
		#g = Gangleader
		#z = Sucker
		var ColStr:String
		if (width+height)%2 == 0:
			ColStr = "b"
		else:
			ColStr = "w"
		match ch:
			'#':
				ColStr += "_"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'B':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'H':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'M':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'R':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'm':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'h':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			's':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'a':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'g':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'z':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				width += 1;
			'\n':
				height = height + 1
				width = 0
			_:
				width = width + 1
	return

#addsTile. width and height are integers. The conversion into world space is 
func addTile(width,height,type):
	print("uzgzu")
	var tile = tile_scene.instantiate()
	#set color base on checkerboard pattern
	tile.position = Vector3(width, 0, height)
	tile.set_color(type)
	add_child(tile)
	return tile;
