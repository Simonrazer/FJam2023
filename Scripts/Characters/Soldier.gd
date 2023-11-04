class_name Soldier extends CharacterBase

#exports necesarry?
@export_category("Soldier Base Stats")
@export var soldier_base_health: int = 5
@export var soldier_base_armor: int = 1
@export var soldier_base_movement: int = 2
@export var soldier_base_damage: Vector2 = Vector2(-4, -1)
@export var soldier_base_steal: Vector2 = Vector2(-2, 1)
@export var soldier_base_heal: Vector2 = Vector2(0, 0)
@export var soldier_base_damage_range: int = 1
@export var soldier_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.Soldier
	is_playable = false
	
	base_health = soldier_base_health
	base_armor = soldier_base_armor
	movement = soldier_base_movement
	damage = soldier_base_damage
	steal = soldier_base_steal
	heal = soldier_base_heal
	damage_range = soldier_base_damage_range
	heal_range = soldier_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
