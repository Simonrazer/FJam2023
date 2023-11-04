class_name Hound extends CharacterBase

#exports necesarry?
@export_category("Hound Base Stats")
@export var hound_base_health: int = 4
@export var hound_base_armor: int = 0
@export var hound_base_movement: int = 4
@export var hound_base_damage: Vector2 = Vector2(-2, 0)
@export var hound_base_steal: Vector2 = Vector2(0, 0)
@export var hound_base_heal: Vector2 = Vector2(0, 0)
@export var hound_base_damage_range: int = 1
@export var hound_base_heal_range: int = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	character_class = Character_Class.Hound
	is_playable = false
	
	base_health = hound_base_health
	base_armor = hound_base_armor
	movement = hound_base_movement
	damage = hound_base_damage
	steal = hound_base_steal
	heal = hound_base_heal
	damage_range = hound_base_damage_range
	heal_range = hound_base_heal_range


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#overwrite class ability if needed
