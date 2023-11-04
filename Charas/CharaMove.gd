extends Node

@export var updown_freq = 0.5
@export var updown_amp = 0.1

@export var updownH_freq = 100000
@export var updownH_amp = 0.1

var _startpos
var holo
var holo2
# Called when the node enters the scene tree for the first time.
func _ready():
	_startpos = self.position
	holo = get_node("Holo")
	holo2 = get_node("Holo2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var _ti = 0
func _process(delta):
	_ti += delta
	self.position.y = sin(_ti/updown_freq)*updown_amp+updown_amp+_startpos.y
	#holo.position.y = sin(_ti/updownH_freq)*updownH_amp-_startpos.y
	holo.rotate(Vector3(0, 1, 0), 0.03)
	holo2.rotate(Vector3(0, 1, 0), 0.035)
	pass
