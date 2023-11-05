extends Node

enum moveEnum{
	attack,
	move
}

var myTurn:bool = false
var countdown:float = 1
var nextMove:int
var possible_moves
var moves
var enemies:Array[CharacterBase]
var players:Array[CharacterBase]
var TileMatrix
var gc
# Called when the node enters the scene tree for the first time.
func _ready():
	gc = get_owner()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(myTurn):
		if(nextMove < moves.size()):
			if(countdown < 0):
				countdown = 1
				#could be done by calling a function in gamecontroller in case its pass my value and shit doesnt update
				match moves[nextMove][0]:
					moveEnum.move:
						print("##moving")
						print(moves[nextMove][2])
						moves[nextMove][1].move(moves[nextMove][2])
					moveEnum.attack:
						print("##attacking")
						print(moves[nextMove][1].position_on_map)
					#TODO ask if this shit is what is ment to happen
						moves[nextMove][1].take_damage(moves[nextMove][2])
					_:
						print("sth went wrong")
				nextMove += 1
			else:
				countdown-=delta
		else:
			myTurn = false
			print("i can no longer move it move it")

#calculates which moves the ai will take next. _process executes them
func calculate_moveset():
	var new_moves = []
	#mb int
	for enemy in enemies:
		#i dont wanna comment any more rest is trivial
		var min_hp:int = 100
		var next_attacked:CharacterBase = null;
		possible_moves = gc.get_possible_moves(enemy.damage_range,enemy.position_on_map)
		for coord in possible_moves:
			for friend in players:
				if coord[0] == friend.position_on_map.x and coord[1] ==friend.position_on_map.y:
					if friend.health < min_hp:
						min_hp = friend.health
						next_attacked = friend
		if next_attacked != null:
			new_moves.append([moveEnum.attack,next_attacked,enemy.damage[0]])
		else:
			var min_dist:int
			min_dist = 100
			var nearest_friend:CharacterBase
			for friend in players:
				var dist:float = (friend.position_on_map.x-enemy.position_on_map.x)*(friend.position_on_map.x-enemy.position_on_map.x)+(friend.position_on_map.y-enemy.position_on_map.y)*(friend.position_on_map.y-enemy.position_on_map.y)
				if dist < min_dist:
					nearest_friend = friend
					min_dist = dist
			var reachable_tiles = gc.get_possible_moves(enemy.movement,enemy.position_on_map)
			var attack_min_dist = 100;
			var current_move;
			for possible_target in reachable_tiles:
				var dist = (nearest_friend.position_on_map.x-possible_target[0])*(nearest_friend.position_on_map.x-possible_target[0])+(nearest_friend.position_on_map.y-possible_target[1])*(nearest_friend.position_on_map.y-possible_target[1])
				if dist < attack_min_dist:
					if(dist > 0):
						attack_min_dist = dist
						current_move = possible_target
			new_moves.append([moveEnum.move,enemy,Vector2(current_move[0],current_move[1])])
	moves =  new_moves

#called by GameController
func my_turn(gcTileMatrix, gcenemies:Array[CharacterBase], gcplayers:Array[CharacterBase]):
	enemies = gcenemies
	players = gcplayers
	TileMatrix = gcTileMatrix
	myTurn = true
	calculate_moveset()
	
