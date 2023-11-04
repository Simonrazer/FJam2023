extends Sprite3D

@export var updown_freq = 0.5
@export var updown_amp = 0.1

@export var updownH_freq = 100000
@export var updownH_amp = 0.1

var sprites: Array[CompressedTexture2D]
var sprites_size: int = 20

var _startpos
var holo
var holo2

var movin = false
var moveTo
var counter = 0
var startPos

var hpscale:Node3D
# Called when the node enters the scene tree for the first time.
func _ready():
	_startpos = self.position
	holo = get_node("Holo")
	holo2 = get_node("Holo2")
	hpscale = get_node("HPScaler")

	#load all sprites
	sprites.resize(sprites_size)
	#friendly:
	sprites[CharacterBase.Character_Class.Brute] = preload("res://Charas/Headshot_Brutus.png")
	sprites[CharacterBase.Character_Class.Milo] = preload("res://Charas/Headshot_Milo.png")
	#enemy:
	sprites[CharacterBase.Character_Class.Minion] = preload("res://Charas/Schlager.png")
	sprites[CharacterBase.Character_Class.Hound] = preload("res://Charas/Bluthund.png")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var _ti = 0
func _process(delta):
	_ti += delta
	self.position.y = sin(_ti/updown_freq)*updown_amp+updown_amp+_startpos.y
	#holo.position.y = sin(_ti/updownH_freq)*updownH_amp-_startpos.y
	holo.rotate(Vector3(0, 1, 0), 0.03)
	holo2.rotate(Vector3(0, 1, 0), 0.035)
	
	if movin:
		global_position = global_position.lerp(moveTo, delta*2)
		counter += delta
		if counter >= 2:
			global_position.x = moveTo.x
			global_position.z = moveTo.z
			counter = 0
			movin = false
	pass

func hpScale(perc):
	hpscale.set_scale(Vector3(perc,1,1))

func doMove(newPos:Vector3):
	movin = true
	startPos = global_position
	moveTo = newPos

func init_sprite(desired_sprite: CharacterBase.Character_Class):
	texture = sprites[desired_sprite]
	pixel_size *= 768 / float(texture.get_width())

func set_armor(armor: int):
	print(armor)
	get_node("ArmorPacks").frame = 4 - armor
