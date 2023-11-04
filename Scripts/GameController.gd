extends Node3D

@onready var file = 'res://Maps/map1.txt'

var tile_scene
var TileMatrix=[] # oben (0,0) nach unten (1, 0) nach rechts (0,1)
var Map_Width: int
var Map_Height: int

var list_of_players: Array[CharacterBase]
var list_of_enemies: Array[CharacterBase]

func _ready():
	tile_scene = preload("res://Prefabs/tile.tscn")
	load_file(file)

func load_file(file):
	var fileObj = FileAccess.open(file, FileAccess.READ)
	var content:String = fileObj.get_as_text()
	var width = 0
	var height = 0
	
	var lines = content.split('\n')
	Map_Width = lines[0].length()
	Map_Height = content.count("\n")
	
	for x in range(Map_Width):
		TileMatrix.append([])
		#glaube das braucht man nicht aber you never know
		for y in range(Map_Height):
			TileMatrix[x].append(0)
	for ch in content:
		# eigene Charactere:
		## = Tile
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
				var brute: CharacterBase
				brute = TheBrute.new()
				brute.init_character(Vector2(width, height))
				list_of_players.append(brute)
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

var all_colored_tiles: Array[Tile]

#utility functions
func color_range(action_length: int, center: Vector2):
	for i in range(-action_length, action_length):
				for j in range(-action_length, action_length):
					var tile_pos: Vector2 = Vector2(center.x + i, center.y + j)
					
					if i == 0 and j == 0: continue
					if tile_pos.x < 0 or tile_pos.y < 0: continue
					if tile_pos.x >= Map_Width or tile_pos.y >= Map_Height: continue
					if TileMatrix[tile_pos.y][tile_pos.x] == 0: continue
					
					TileMatrix[tile_pos.y][tile_pos.x].highlight
					all_colored_tiles.append(TileMatrix[tile_pos.y][tile_pos.x])

func clear_all_colored_tiles():
	for tile in all_colored_tiles:
		tile.reset_color()
	all_colored_tiles.clear()

func check_for_any_moves():
	for player in list_of_players:
		if player.has_actions(): return true

#state machine functions
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
			for player in list_of_players:
				if player.get_pos() != tile: continue
				if player.has_actions():
					current_state = GameControlStates.PlayerSelected
					current_selected_character = player
					
					TileMatrix[tile.y][tile.x].highlight
					all_colored_tiles.append(TileMatrix[tile.y][tile.x])
					
					var moves_available: Array[bool] = current_selected_character.getMoves()
					break

			#	moveButton.setActive(moves_available[0])
			#	healButton.setActive(moves_available[1])
			#	stealButton.setActive(moves_available[1])
			#	damageButton.setActive(moves_available[1])
			#	classButton.setActive(moves_available[1])
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit
			clear_all_colored_tiles()

func change_state_from_PlayerSelected(change: ChangeTrigger,  tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			current_state = GameControlStates.PlayerRound
			clear_all_colored_tiles()
			current_selected_character = null
		ChangeTrigger.Move:
			current_state = GameControlStates.PlayerMoving
			color_range(current_selected_character.get_movement_stat(), current_selected_character.get_pos())
		ChangeTrigger.Heal:
			current_state = GameControlStates.PlayerHealing
			color_range(current_selected_character.get_action_range(CharacterBase.Action.Heal), current_selected_character.get_pos())
		ChangeTrigger.Steal:
			current_state = GameControlStates.PlayerDamaging
			color_range(current_selected_character.get_action_range(CharacterBase.Action.Steal), current_selected_character.get_pos())
		ChangeTrigger.Damage:
			current_state = GameControlStates.PlayerDamaging
			color_range(current_selected_character.get_action_range(CharacterBase.Action.Damage), current_selected_character.get_pos())
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit
			clear_all_colored_tiles()

func change_state_from_PlayerMoving(change: ChangeTrigger, tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			if current_selected_character.move(tile):
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: current_state = GameControlStates.EnemyInit
				clear_all_colored_tiles()
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit
			clear_all_colored_tiles()
			

