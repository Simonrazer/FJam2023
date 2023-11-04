class_name Hetzer extends CharacterBase

#exports necesarry?
@export_category("Hetzer Base Stats")
@export var hetzer_base_health: int = 5
@export var hetzer_base_armor: int = 0
@export var hetzer_base_movement: int = 4
@export var hetzer_base_damage: Vector2 = Vector2(-4, -1)
@export var hetzer_base_steal: Vector2 = Vector2(-3, 2)
@export var hetzer_base_heal: Vector2 = Vector2(2, -2)
@export var hetzer_base_damage_range: int = 1
@export var hetzer_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func initChild():
	character_class = Character_Class.Hetzer
	is_playable = true
	
	base_health = hetzer_base_health
	base_armor = hetzer_base_armor
	movement = hetzer_base_movement
	damage = hetzer_base_damage
	steal = hetzer_base_steal
	heal = hetzer_base_heal
	damage_range = hetzer_base_damage_range
	heal_range = hetzer_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
