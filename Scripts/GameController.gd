class_name GameController extends Node3D

@onready var file = 'res://Maps/map1.txt'



var tile_scene
var chara_scene
var TileMatrix=[] # oben (0,0) nach unten (1, 0) nach rechts (0,1)
var Map_Width: int
var Map_Height: int

var list_of_players: Array[CharacterBase]
var list_of_enemies: Array[CharacterBase]

func _ready():
	tile_scene = preload("res://Prefabs/tile.tscn")
	chara_scene = preload("res://Charas/Chara.tscn")
	load_file(file)

func instantiate_entity(pos: Vector2, is_enemy: bool, ColStr: String, type: CharacterBase.Character_Class):
	var chara = chara_scene.instantiate()
	chara.position = Vector3(pos.x, 0, pos.y)
	add_child(chara)
	chara.get_child(0).init_sprite(type)
	
	var entity: CharacterBase
	match(type):
		#friendly
		CharacterBase.Character_Class.Brute: entity = TheBrute.new()
		CharacterBase.Character_Class.Milo: entity = Milo.new()
		#enemy
		CharacterBase.Character_Class.Minion: entity = Minion.new()
		CharacterBase.Character_Class.Hound: entity = Hound.new()
		
	entity.initChild()
	entity.set_model(chara)
	entity.init_character(pos)
	if is_enemy: list_of_enemies.append(entity)
	else: list_of_players.append(entity)

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
			TileMatrix[x].append(null)
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
				instantiate_entity(Vector2(width, height), false, ColStr, CharacterBase.Character_Class.Brute)
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
	var tile = tile_scene.instantiate()
	#set color base on checkerboard pattern
	tile.position = Vector3(width, 0, height)
	tile.set_color(type)
	tile.set_game_controller(self)
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

@export var current_state: GameControlStates = GameControlStates.PlayerRound
@export var current_selected_character: CharacterBase = null

var all_colored_tiles: Array[Tile]

#utility functions
func color_range(action_length: int, center: Vector2):
	for i in range(-action_length, action_length + 1):
		for j in range(-action_length, action_length + 1):
			var tile_pos: Vector2 = Vector2(center.x + i, center.y + j)
			
			if i == 0 and j == 0: continue
			if tile_pos.x < 0 or tile_pos.y < 0: continue
			if tile_pos.x >= Map_Width or tile_pos.y >= Map_Height: continue
			if TileMatrix[tile_pos.x][tile_pos.y] == null: continue
			
			TileMatrix[tile_pos.x][tile_pos.y].highlight()
			all_colored_tiles.append(TileMatrix[tile_pos.y][tile_pos.x])

func clear_all_colored_tiles():
	for tile in all_colored_tiles:
		tile.reset_color()
	all_colored_tiles.clear()
	print(len(all_colored_tiles))

func check_for_any_moves():
	for player in list_of_players:
		if player.has_actions(): return true

#state machine functions
func change_state(change: ChangeTrigger, tile: Vector2): #parameters?
	print("Old State: ", GameControlStates.keys()[current_state])
	print("Change Trigger: ", ChangeTrigger.keys()[change])
	match current_state:
		GameControlStates.PlayerRound:
			change_state_from_PlayerRound(change, tile)
		GameControlStates.PlayerSelected:
			change_state_from_PlayerSelected(change, tile)
		GameControlStates.PlayerMoving:
			change_state_from_PlayerMoving(change, tile)
		GameControlStates.PlayerHealing:
			pass
		GameControlStates.PlayerDamaging:
			pass
	
	print("New State: ", GameControlStates.keys()[current_state])
	print("")

func change_state_from_PlayerRound(change: ChangeTrigger,  tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			for player in list_of_players:
				if player.get_pos() != tile: continue
				if player.has_actions():
					current_state = GameControlStates.PlayerSelected
					current_selected_character = player
					
					TileMatrix[tile.x][tile.y].highlight()
					all_colored_tiles.append(TileMatrix[tile.x][tile.y])
					
					var moves_available: Array[bool] = current_selected_character.get_actions()
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
			if not current_selected_character.get_actions()[0]: return
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
				
				current_selected_character.model.position = Vector3(current_selected_character.get_pos().x, 0, current_selected_character.get_pos().y)
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: current_state = GameControlStates.EnemyInit
				clear_all_colored_tiles()
		ChangeTrigger.Move:
			current_state = GameControlStates.PlayerSelected
			clear_all_colored_tiles()
			TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y].highlight()
			all_colored_tiles.append(TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y])
			
		ChangeTrigger.EndRound:
			current_state = GameControlStates.EnemyInit
			clear_all_colored_tiles()

func _move_btn_click():
	change_state(ChangeTrigger.Move, Vector2())
