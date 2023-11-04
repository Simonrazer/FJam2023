class_name Milo extends CharacterBase

#exports necesarry?
@export_category("Milo Base Stats")
@export var milo_base_health: int = 5
@export var milo_base_armor: int = 0
@export var milo_base_movement: int = 4
@export var milo_base_damage: Vector2 = Vector2(-4, -1)
@export var milo_base_steal: Vector2 = Vector2(-2, 1)
@export var milo_base_heal: Vector2 = Vector2(3, -1)
@export var milo_base_damage_range: int = 1
@export var milo_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func initChild():
	character_class = Character_Class.Milo
	is_playable = true
	
	base_health = milo_base_health
	base_armor = milo_base_armor
	movement = milo_base_movement
	damage = milo_base_damage
	steal = milo_base_steal
	heal = milo_base_heal
	damage_range = milo_base_damage_range
	heal_range = milo_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
