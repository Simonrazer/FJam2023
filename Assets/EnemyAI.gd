extends Node

enum moveEnum{
	attack,
	steal,
	move
}

var restricted_tiles:Array[Vector2]
var done_calculating:bool
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
		if(done_calculating):
			if(nextMove < moves.size()):
				if(countdown < 0):
					countdown = 1
					#could be done by calling a function in gamecontroller in case its pass my value and shit doesnt update
					match moves[nextMove][0]:
						moveEnum.move:
							moves[nextMove][1].move(moves[nextMove][2])
						moveEnum.attack:
							if moves[nextMove][1].health > 0:
								moves[nextMove][1].take_damage(moves[nextMove][2])
						moveEnum.steal:
							moves[nextMove][1].take_damage(moves[nextMove][2])
						_:
							print("sth went wrong")
					nextMove += 1
				else:
					countdown-=delta
			else:
				myTurn = false
				print("i can no longer move it move it")
				gc.yourTurn()

#calculates which moves the ai will take next. _process executes them
func calculate_moveset():
	var new_moves = []
	var enemy_int:int
	enemy_int = 0
	for enemy in enemies:
		#i dont wanna comment any more rest is trivial
		var min_hp:int = 100
		var next_attacked:CharacterBase = null;
		possible_moves = gc.get_possible_moves(enemy.damage_range,enemy.position_on_map,restricted_tiles)
		for coord in possible_moves:
			for friend in players:
				if coord[0] == friend.position_on_map.x and coord[1] ==friend.position_on_map.y:
					if friend.health < min_hp:
						min_hp = friend.health
						next_attacked = friend
		print(enemy_int)
		if next_attacked != null:
			if enemy.health > enemy.base_health*0.5:
				new_moves.append([moveEnum.attack,next_attacked,enemy.damage[0]])
			else:
				new_moves.append([moveEnum.steal,next_attacked,enemy.steal[0]])
		else:
			var min_dist:int
			min_dist = 100
			var nearest_friend:CharacterBase
			for friend in players:
				var dist:float = (friend.position_on_map.x-enemy.position_on_map.x)*(friend.position_on_map.x-enemy.position_on_map.x)+(friend.position_on_map.y-enemy.position_on_map.y)*(friend.position_on_map.y-enemy.position_on_map.y)
				if dist < min_dist:
					nearest_friend = friend
					min_dist = dist
			var reachable_tiles = gc.get_possible_moves(enemy.movement,enemy.position_on_map,restricted_tiles)
			var attack_min_dist = 100;
			var current_move;
			for possible_target in reachable_tiles:
				var dist = (nearest_friend.position_on_map.x-possible_target[0])*(nearest_friend.position_on_map.x-possible_target[0])+(nearest_friend.position_on_map.y-possible_target[1])*(nearest_friend.position_on_map.y-possible_target[1])
				if dist < attack_min_dist:
					if(dist > 0):
						attack_min_dist = dist
						current_move = possible_target
			new_moves.append([moveEnum.move,enemy,Vector2(current_move[0],current_move[1])])
			restricted_tiles[enemy_int] = Vector2(current_move[0],current_move[1])
			var attackable_tiles = gc.get_possible_moves(enemy.damage_range,Vector2(current_move[0],current_move[1]),restricted_tiles)
			for coord in attackable_tiles:
				if coord[0] == nearest_friend.position_on_map.x and coord[1] == nearest_friend.position_on_map.y:
					if enemy.health > enemy.base_health*0.5:
						new_moves.append([moveEnum.attack,nearest_friend,enemy.damage[0]])
					else:
						new_moves.append([moveEnum.steal,nearest_friend,enemy.damage[0]])
		enemy_int += 1
	moves =  new_moves

#called by GameController
func my_turn(gcTileMatrix, gcenemies:Array[CharacterBase], gcplayers:Array[CharacterBase]):
	done_calculating = false
	myTurn = true
	enemies = gcenemies
	players = gcplayers
	TileMatrix = gcTileMatrix
	nextMove = 0
	for enemy in gcenemies:
		restricted_tiles.append(enemy.position_on_map)
	
	calculate_moveset()
	done_calculating = true
