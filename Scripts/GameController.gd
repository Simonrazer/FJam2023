class_name GameController extends Node3D

@onready var file = 'res://Maps/map1.txt'



var tile_scene
var chara_scene
var TileMatrix=[] # oben (0,0) nach unten (1, 0) nach rechts (0,1)
var Map_Width: int
var Map_Height: int

var list_of_players: Array[CharacterBase]
var list_of_enemies: Array[CharacterBase]

var buttons: Array[Button]
var end_round_button: Button

var sprites: Array[CompressedTexture2D]
var sprites_size: int = 20
func _ready():
	sprites.resize(sprites_size)
	#friendly:
	sprites[CharacterBase.Character_Class.Brute] = preload("res://Charas/Headshot_Brutus.png")
	sprites[CharacterBase.Character_Class.Milo] = preload("res://Charas/Headshot_Milo.png")
	#enemy:
	sprites[CharacterBase.Character_Class.Minion] = preload("res://Charas/Schlager.png")
	sprites[CharacterBase.Character_Class.Hound] = preload("res://Charas/Bluthund.png")
	tile_scene = preload("res://Prefabs/tile.tscn")
	chara_scene = preload("res://Charas/Chara.tscn")
	load_file(file)
	buttons.resize(6)
	init_buttons_array()

var lastChar:CharacterBase = null
func _process(delta):
	if lastChar != current_selected_character:
		lastChar = current_selected_character
		if lastChar == null: 
			get_node("UI/CanvasLayer/ColorRect/currentImg").texture = null
		else:
			get_node("UI/CanvasLayer/ColorRect/currentImg").texture = sprites[current_selected_character.character_class]
			get_node("UI/CanvasLayer/ColorRect/currentImg").size = Vector2(100,100)
	
	check_for_EOG()


func init_buttons_array():
	buttons[0] = get_node("UI/CanvasLayer/ColorRect/MoveButton")
	buttons[0].button_down.connect(_move_btn_click)
	buttons[1] = get_node("UI/CanvasLayer/ColorRect/AttackButton")
	buttons[1].button_down.connect(_attack_btn_click)
	buttons[2] = get_node("UI/CanvasLayer/ColorRect/StealButton")
	buttons[2].button_down.connect(_steal_btn_click)
	buttons[3] = get_node("UI/CanvasLayer/ColorRect/HealButton")
	buttons[3].button_down.connect(_heal_btn_click)
	buttons[4] = get_node("UI/CanvasLayer/ColorRect/ClassButton")
	buttons[4].button_down.connect(_class_btn_click)
	buttons[5] = get_node("UI/CanvasLayer/ColorRect/<ITEM>")
	buttons[5].button_down.connect(_item_btn_click)
	
	end_round_button = get_node("UI/CanvasLayer/EndRoundButton")
	end_round_button.button_down.connect(_end_round_btn_click)

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
	entity.init_character(pos)
	entity.set_model(chara)
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
				instantiate_entity(Vector2(width, height), false, ColStr, CharacterBase.Character_Class.Hetzer)
				width += 1;
			'M':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), false, ColStr, CharacterBase.Character_Class.Milo)
				width += 1;
			'R':
				ColStr += "f"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), false, ColStr, CharacterBase.Character_Class.Rock)
				width += 1;
			'm':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.Minion)
				width += 1;
			'h':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.Hound)
				width += 1;
			's':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.Soldier)
				width += 1;
			'a':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.Archer)
				width += 1;
			'g':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.GangLeader)
				width += 1;
			'z':
				ColStr += "e"
				TileMatrix[width][height] = addTile(width,height, ColStr)
				instantiate_entity(Vector2(width, height), true, ColStr, CharacterBase.Character_Class.Sucker)
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
	PlayerStealing,
	
	EnemyRound,
	EnemyInit,
}

enum ChangeTrigger {
	Tile,
	Move,
	Heal,
	Steal,
	Damage,
	ClassAbility,
	ItemUse,
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
			if (i*i + j*j) > action_length*action_length: continue
			
			TileMatrix[tile_pos.x][tile_pos.y].highlight()
			all_colored_tiles.append(TileMatrix[tile_pos.x][tile_pos.y ])

func clear_all_colored_tiles():
	for tile in all_colored_tiles:
		tile.reset_color()
	all_colored_tiles.clear()
	print(len(all_colored_tiles))

func check_for_any_moves():
	for player in list_of_players:
		if player.has_actions(): return true

func end_round_function():
	clear_all_colored_tiles()
	current_selected_character = null
	current_state = GameControlStates.EnemyInit
	get_node("EnemyAI").my_turn(TileMatrix,list_of_enemies,list_of_players)


func get_entity_at_pos(pos: Vector2, list: Array[CharacterBase]):
	for entity in list:
		if entity.get_pos() == pos: return entity
	
	return null

func check_for_EOG():
	if list_of_players.size() == 0: print("dead")
	if list_of_enemies.size() == 0: print("alive")

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
			change_state_from_PlayerHealing(change, tile)
		GameControlStates.PlayerDamaging:
			change_state_from_PlayerDamaging(change, tile)
		GameControlStates.PlayerStealing:
			change_state_from_PlayerStealing(change, tile)
	
	print("New State: ", GameControlStates.keys()[current_state])
	print("")

#ALL STATE CHANGED FROM FUNCTIONS
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
					buttons[0].disabled = !moves_available[0]
					buttons[1].disabled = !moves_available[1]
					buttons[2].disabled = !moves_available[1]
					buttons[3].disabled = !moves_available[1]
					buttons[4].disabled = !moves_available[2]
					buttons[5].disabled = !moves_available[2] #should be 3 -> CHANGE
					
		ChangeTrigger.EndRound:
			end_round_function()

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
			current_state = GameControlStates.PlayerStealing
			color_range(current_selected_character.get_action_range(CharacterBase.Action.Steal), current_selected_character.get_pos())
		ChangeTrigger.Damage:
			current_state = GameControlStates.PlayerDamaging
			color_range(current_selected_character.get_action_range(CharacterBase.Action.Damage), current_selected_character.get_pos())
		ChangeTrigger.EndRound:
			end_round_function()

func change_state_from_PlayerMoving(change: ChangeTrigger, tile: Vector2):
	match change:
		ChangeTrigger.Tile:
			var original_pos: Vector2 = current_selected_character.get_pos()
			var get_possible_enemy: CharacterBase = get_entity_at_pos(tile, list_of_enemies)
			var get_possible_player: CharacterBase = get_entity_at_pos(tile, list_of_players)
			if get_possible_enemy != null or get_possible_player != null: return
			
			if current_selected_character.move(tile):
				TileMatrix[tile.x][tile.y].change_color("f")
				TileMatrix[original_pos.x][original_pos.y].change_color("_")
				clear_all_colored_tiles()
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: end_round_function()
		ChangeTrigger.Move:
			current_state = GameControlStates.PlayerSelected
			clear_all_colored_tiles()
			TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y].highlight()
			all_colored_tiles.append(TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y])
			
		ChangeTrigger.EndRound:
			end_round_function()

func change_state_from_PlayerHealing(change: ChangeTrigger,  tile: Vector2):
	match change:
		ChangeTrigger.Heal:
			current_state = GameControlStates.PlayerSelected
			clear_all_colored_tiles()
			TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y].highlight()
			all_colored_tiles.append(TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y])
		ChangeTrigger.Tile:
			var entity: CharacterBase = get_entity_at_pos(tile, list_of_players)
			if current_selected_character.do_action(tile, CharacterBase.Action.Heal, entity):
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: end_round_function()
				clear_all_colored_tiles()
		ChangeTrigger.EndRound:
			end_round_function()
			

func change_state_from_PlayerDamaging(change: ChangeTrigger, tile: Vector2):
	match change:
		ChangeTrigger.Damage:
			current_state = GameControlStates.PlayerSelected
			clear_all_colored_tiles()
			TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y].highlight()
			all_colored_tiles.append(TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y])
		ChangeTrigger.Tile:
			var entity: CharacterBase = get_entity_at_pos(tile, list_of_enemies)
			if current_selected_character.do_action(tile, CharacterBase.Action.Damage, entity):
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: end_round_function()
				clear_all_colored_tiles()
		ChangeTrigger.EndRound:
			end_round_function()
				
func change_state_from_PlayerStealing(change: ChangeTrigger, tile: Vector2):
	match change:
		ChangeTrigger.Steal:
			current_state = GameControlStates.PlayerSelected
			clear_all_colored_tiles()
			TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y].highlight()
			all_colored_tiles.append(TileMatrix[current_selected_character.get_pos().x][current_selected_character.get_pos().y])
		ChangeTrigger.Tile:
			var entity: CharacterBase = get_entity_at_pos(tile, list_of_enemies)
			if current_selected_character.do_action(tile, CharacterBase.Action.Steal, entity):
				if check_for_any_moves(): current_state = GameControlStates.PlayerRound
				else: end_round_function()
				clear_all_colored_tiles()
		ChangeTrigger.EndRound:
			end_round_function()

#ALL BUTTON FUNCTIONS
func _move_btn_click():
	change_state(ChangeTrigger.Move, Vector2())

func _attack_btn_click():
	change_state(ChangeTrigger.Damage, Vector2())

func _steal_btn_click():
	change_state(ChangeTrigger.Steal, Vector2())

func _heal_btn_click():
	change_state(ChangeTrigger.Heal, Vector2())

func _class_btn_click():
	change_state(ChangeTrigger.ClassAbility, Vector2())

func _item_btn_click():
	change_state(ChangeTrigger.ItemUse, Vector2())

func _end_round_btn_click():
	change_state(ChangeTrigger.EndRound, Vector2())

func get_possible_moves(action_length: int, center: Vector2):
	var possible_moves = []
	for i in range(-action_length, action_length + 1):
		for j in range(-action_length, action_length + 1):
			var tile_pos: Vector2 = Vector2(center.x + i, center.y + j)
			
			if i == 0 and j == 0: continue
			if tile_pos.x < 0 or tile_pos.y < 0: continue
			if tile_pos.x >= Map_Width or tile_pos.y >= Map_Height: continue
			if TileMatrix[tile_pos.x][tile_pos.y] == null: continue
			if (i*i + j*j) > action_length*action_length: continue
			
			possible_moves.append([tile_pos.x,tile_pos.y])
	return possible_moves
