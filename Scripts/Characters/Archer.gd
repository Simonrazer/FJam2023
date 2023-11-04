class_name Minion extends CharacterBase

#exports necesarry?
@export_category("Minion Base Stats")
@export var minion_base_health: int = 3
@export var minion_base_armor: int = 0
@export var minion_base_movement: int = 1
@export var minion_base_damage: Vector2 = Vector2(-3, 0)
#TODO THIS IS SUPPOSED TO BE RANGE I DONT KNOW HOW TO HANDLE PLS HELP
@export var minion_base_steal: Vector2 = Vector2(0, 0)
@export var minion_base_heal: Vector2 = Vector2(0, 0)
@export var minion_base_damage_range: int = 2
@export var minion_base_heal_range: int = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.Minion
	is_playable = false
	
	base_health = minion_base_health
	base_armor = minion_base_armor
	movement = minion_base_movement
	damage = minion_base_damage
	steal = minion_base_steal
	heal = minion_base_heal
	damage_range = minion_base_damage_range
	heal_range = minion_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
