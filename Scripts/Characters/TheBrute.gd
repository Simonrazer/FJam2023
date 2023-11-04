class_name TheBrute extends CharacterBase

#exports necesarry?
@export_category("Brute Base Stats")
@export var brute_base_health: int = 7
@export var brute_base_armor: int = 0
@export var brute_base_movement: int = 2
@export var brute_base_damage: Vector2 = Vector2(-5, 0)
@export var brute_base_steal: Vector2 = Vector2(-2, 1)
@export var brute_base_heal: Vector2 = Vector2(2, -2)
@export var brute_base_damage_range: int = 1
@export var brute_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.Brute
	is_playable = true
	
	base_health = brute_base_health
	base_armor = brute_base_armor
	movement = brute_base_movement
	damage = brute_base_damage
	steal = brute_base_steal
	heal = brute_base_heal
	damage_range = brute_base_damage_range
	heal_range = brute_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
