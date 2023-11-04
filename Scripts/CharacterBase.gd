class_name CharacterBase extends Node

enum Character_Class {
	#player character
	Brute,
	Magician,
	Bloodhound,
	Rock,
	
	#enemy character
	Minion,
	Solder,
	Hound,
	Archer,
	GangLeader,
	Sucker,
}

enum Action {
	Damage,
	Steal,
	Heal,
}

@export_category("Class")
@export var character_class: Character_Class
@export var is_playable: bool

@export_category("Base stats")
@export var base_health: int  
@export var base_armor: int
@export var movement: int
#for all Vector2 stats: x -> other | y -> self
@export var damage: Vector2
@export var steal: Vector2
@export var heal: Vector2
@export var damage_range: int
@export var heal_range: int

@export_category("Current Stats")
@export var armor: int
@export var health: int
@export var position_on_map: Vector2
# 0 -> can move | 1 -> can attack / steal / heal | 2 -> can class ability
@export var actions: Array[bool]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func init_character(start_pos: Vector2):
	armor = base_armor
	health = base_health;
	position_on_map = start_pos
	actions = [true, true, true] #maybe not necessary

func start_new_round():
	actions = [true, true, true]

func move(new_pos: Vector2):
	var move_vector = Vector2(new_pos.x - position_on_map.x, new_pos.y - position_on_map.y)
	
	if abs(move_vector.x) > movement or abs(move_vector.y) > movement:
		return false #ERROR
	
	position_on_map = new_pos
	#TODO implement on squares -> Game controller get new pos
	actions[0] = false
	return true

func do_action(target_pos: Vector2, action: Action):
	var return_value: bool
	
	if action == Action.Damage:
		return_value = attack_ability(target_pos, damage, false)
	
	if action == Action.Steal:
		return_value = attack_ability(target_pos, steal, true)
	
	if action == Action.Heal:
		return_value = heal_ability(target_pos)
	
	if return_value == false:
		return false
	
	actions[1] = false
	return true

func attack_ability(enemy_pos: Vector2, action_stats: Vector2, is_steal: bool):
	var diff_vector = Vector2(enemy_pos.x - position_on_map.x, enemy_pos.y - position_on_map.y)
	
	if abs(diff_vector.x) > damage_range or abs(diff_vector.y) > damage_range:
		return false #ERROR

	#TODO check if enemy else return false
	#TODO get enemy CharacterBase
	var return_value: bool = 0 
	#TODO return value = enemy.take_damage(action_stat.x)
	
	if is_steal and not return_value:
		health += action_stats.y
	
	check_for_death()
	
	return true
	

func heal_ability(ally_pos: Vector2):
	var diff_vector = Vector2(ally_pos.x - position_on_map.x, ally_pos.y - position_on_map.y)
	
	if abs(diff_vector.x) > heal_range or abs(diff_vector.y) > heal_range:
		return false #ERROR
	
	#TODO check if ally else return false
	#TODO get ally CharacterBase
	#TODO ally.get_healed(heal.x)
	health -= heal.y
	check_for_death()
	
	return true

func class_ability():
	pass #remember to set actions[2] to false

func get_healed(heal_to_get: int):
	health += heal_to_get

func take_damage(damage_to_take: int):
	armor -= damage_to_take
	
	if armor < 0:
		var health_diff: int
		
		health_diff = -armor
		health -= health_diff
		armor = 0
		check_for_death()
		return true
	
	return false
	
func check_for_death():
	if health <= 0:
		pass #away

#GET FUNCTIONS FOR GAME CONTROLLER
func get_pos():
	return position_on_map

func get_movement_stat():
	return movement

func get_actions():
	return actions

func has_actions():
	return actions[0] and actions[1] and actions[2]

func get_action_range(action: Action):
	
	if action == Action.Damage or action == Action.Steal:
		return damage_range
	
	if action == Action.Heal:
		return heal_range
	
	return -1
