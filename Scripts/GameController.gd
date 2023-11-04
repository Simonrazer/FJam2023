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


###
### ATTENTION ------ STATE MACHINE BELOW
###

enum GameControlStates {
	Start,
	
	PlayerRound,
	PlayerInit,
	PlayerSelected,
	PlayerMoving,
	PlayerHealing,
	PlayerDamaging,
	
	EnemyRound,
	EnemyInit,
}

enum ChangeTrigger {
	Tile,
	Move,
	Heal,
	Steal,
	Damage,
	EndRound,
}

@export var current_state: GameControlStates = GameControlStates.Start
@export var current_selected_character: CharacterBase = null

func change_state(change: ChangeTrigger, tile: Vector2): #parameters?
	match current_state:
		GameControlStates.PlayerRound:
			change_state_from_PlayerRound(change, tile)
		GameControlStates.PlayerSelected:
			change_state_from_PlayerSelected(change, tile)
		GameControlStates.PlayerMoving:
			pass
		GameControlStates.PlayerHealing:
			pass
		GameControlStates.PlayerDamaging:
			pass
			

func change_state_from_PlayerRound(change: ChangeTrigger,  tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			#if tile == player and player.has_moves():
			#	current_state = GameControlStates.PlayerSelected
			#	
			#	color tile clicked
			#	current_selected_character = player from list at tile pos
			#	var moves_available: Array[bool] = current_selected_character.getMoves()
			#	moveButton.setActive(moves_available[0])
			#	healButton.setActive(moves_available[1])
			#	stealButton.setActive(moves_available[1])
			#	damageButton.setActive(moves_available[1])
			#	classButton.setActive(moves_available[1])
			pass 
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit

func change_state_from_PlayerSelected(change: ChangeTrigger,  tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			current_state = GameControlStates.PlayerRound
			# revert color change of player tile
			current_selected_character = null
		ChangeTrigger.Move:
			current_state = GameControlStates.PlayerMoving
			var move_length: int = current_selected_character.get_movement_stat()
			for i in range(-move_length, move_length):
				for j in range(-move_length, move_length):
					# color stuff, maybe save what has been colored? then one method to uncolor everything
					pass
		ChangeTrigger.Heal:
			current_state = GameControlStates.PlayerHealing
			var move_length: int = current_selected_character.get_action_range(CharacterBase.Action.Heal)
			for i in range(-move_length, move_length):
				for j in range(-move_length, move_length):
					# color stuff, maybe save what has been colored? then one method to uncolor everything
					# this is also used for steal and damage, give its own method?
					pass
		ChangeTrigger.Steal:
			current_state = GameControlStates.PlayerDamaging
		ChangeTrigger.Damage:
			current_state = GameControlStates.PlayerDamaging
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit

func change_state_from_PlayerMoving(change: ChangeTrigger, tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			if current_selected_character.move(tile):
				pass
			

