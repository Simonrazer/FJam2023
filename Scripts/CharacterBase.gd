class_name CharacterBase extends Node

enum Character_Class {
	#player character
	Brute,
	Milo,
	Hetzer,
	Rock,
	
	#enemy character
	Minion,
	Soldier,
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
@export var model: Node3D

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
	
	if abs(move_vector.x * move_vector.x + move_vector.y * move_vector.y) > movement*movement: return false #ERROR
	
	position_on_map = new_pos
	self.model.get_node("Sprite3D").doMove(Vector3(position_on_map.x, 0, position_on_map.y))
	actions[0] = false
	return true

func do_action(target_pos: Vector2, action: Action, entity: CharacterBase):
	var return_value: bool
	
	match action:
		Action.Damage:
			return_value = attack_ability(target_pos, damage, false, entity)
		Action.Steal:
			return_value = attack_ability(target_pos, steal, true, entity)
		Action.Heal:
			return_value = heal_ability(target_pos, entity)
	
	if return_value == false:
		return false
	
	actions[1] = false
	return true

func attack_ability(enemy_pos: Vector2, action_stats: Vector2, is_steal: bool, entity: CharacterBase):
	var diff_vector = Vector2(enemy_pos.x - position_on_map.x, enemy_pos.y - position_on_map.y)
	
	if abs(diff_vector.x * diff_vector.x + diff_vector.y * diff_vector.y) > damage_range*damage_range: return false #ERROR
	if entity == null: return false

	var return_value: bool = false
	return_value = entity.take_damage(action_stats.x)
	if (action_stats.y <= 0) or (is_steal and not return_value):
		health += action_stats.y
	
	check_for_death()
	
	return true
	

func heal_ability(ally_pos: Vector2, entity: CharacterBase):
	var diff_vector = Vector2(ally_pos.x - position_on_map.x, ally_pos.y - position_on_map.y)

	if abs(diff_vector.x * diff_vector.x + diff_vector.y * diff_vector.y) > damage_range*damage_range: return false #ERROR
	if entity == null: return false

	entity.get_healed(heal.x)
	health += heal.y
	check_for_death()
	
	return true

func class_ability():
	pass #remember to set actions[2] to false

func get_healed(heal_to_get: int):
	health += heal_to_get

func take_damage(damage_to_take: int):
	armor += damage_to_take
	model.get_node("Sprite3D").set_armor(max(0, armor))
	if armor < 0:
		var health_diff: int
		
		health_diff = -armor
		health -= health_diff
		model.get_node("Sprite3D").hpScale(float(health)/max(health, base_health))
		armor = 0
		check_for_death()
		return true
	
	return false
	
func check_for_death():
	if health <= 0:
		pass #away

func set_model(n_model: Node3D):
	model = n_model
	model.get_node("Sprite3D").set_armor(armor)

#GET FUNCTIONS FOR GAME CONTROLLER
func get_pos():
	return position_on_map

func get_movement_stat():
	return movement

func get_actions():
	return actions

func has_actions():
	return actions[0] or actions[1] or actions[2]

func get_action_range(action: Action):
	
	if action == Action.Damage or action == Action.Steal:
		return damage_range
	
	if action == Action.Heal:
		return heal_range
	
	return -1
