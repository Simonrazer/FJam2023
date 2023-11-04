class_name GangLeader extends CharacterBase

#exports necesarry?
@export_category("GangLeader Base Stats")
@export var gangLeader_base_health: int = 10
@export var gangLeader_base_armor: int = 5
@export var gangLeader_base_movement: int = 2
@export var gangLeader_base_damage: Vector2 = Vector2(-4, 0)
@export var gangLeader_base_steal: Vector2 = Vector2(-2, 1)
@export var gangLeader_base_heal: Vector2 = Vector2(0, 0)
@export var gangLeader_base_damage_range: int = 1
@export var gangLeader_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.GangLeader
	is_playable = false
	
	base_health = gangLeader_base_health
	base_armor = gangLeader_base_armor
	movement = gangLeader_base_movement
	damage = gangLeader_base_damage
	steal = gangLeader_base_steal
	heal = gangLeader_base_heal
	damage_range = gangLeader_base_damage_range
	heal_range = gangLeader_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
