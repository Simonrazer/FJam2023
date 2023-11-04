class_name Rock extends CharacterBase

#exports necesarry?
@export_category("Rock Base Stats")
@export var rock_base_health: int = 7
@export var rock_base_armor: int = 4
@export var rock_base_movement: int = 2
@export var rock_base_damage: Vector2 = Vector2(-4, -1)
@export var rock_base_steal: Vector2 = Vector2(-2, 1)
@export var rock_base_heal: Vector2 = Vector2(2, -2)
@export var rock_base_damage_range: int = 1
@export var rock_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func initChild():
	character_class = Character_Class.Rock
	is_playable = true
	
	base_health = rock_base_health
	base_armor = rock_base_armor
	movement = rock_base_movement
	damage = rock_base_damage
	steal = rock_base_steal
	heal = rock_base_heal
	damage_range = rock_base_damage_range
	heal_range = rock_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
