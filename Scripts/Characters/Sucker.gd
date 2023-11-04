class_name Sucker extends CharacterBase

#exports necesarry?
@export_category("Sucker Base Stats")
@export var sucker_base_health: int = 8
@export var sucker_base_armor: int = 0
@export var sucker_base_movement: int = 2
@export var sucker_base_damage: Vector2 = Vector2(-3, 0)
@export var sucker_base_steal: Vector2 = Vector2(-2, 3)
@export var sucker_base_heal: Vector2 = Vector2(0, 0)
@export var sucker_base_damage_range: int = 1
@export var sucker_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.Sucker
	is_playable = false
	
	base_health = sucker_base_health
	base_armor = sucker_base_armor
	movement = sucker_base_movement
	damage = sucker_base_damage
	steal = sucker_base_steal
	heal = sucker_base_heal
	damage_range = sucker_base_damage_range
	heal_range = sucker_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
