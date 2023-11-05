extends Node2D

var i1 : TextureRect
var i2 : TextureRect
var i3 : TextureRect
var i4 : TextureRect
var simultaneous_scene = preload("res://Assets/test_load.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	i1=get_node("CanvasLayer/Boss")
	i2=get_node("CanvasLayer/Brutus")
	i3=get_node("CanvasLayer/Milo")
	i4=get_node("CanvasLayer/Lagerhaus")
	pass # Replace with function body.


var timer = 1.0
var mode = 0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if mode == 1:
		#boss fade out
		i1.set_self_modulate(Color(1,1,1,timer))
		timer -= delta
		if timer < 0:
			mode = 2
			timer = 0.0
			
	elif mode == 2:
		#brutus fade in
		i2.set_self_modulate(Color(1,1,1,timer))
		timer+=delta
		if timer > 1:
			mode = 3
			timer = 0.0
			
	#wait audio = 4
	
	elif mode == 4:
		#milo fade in
		i3.set_self_modulate(Color(1,1,1,timer))
		timer+=delta
		if timer > 1:
			mode = 5
			timer = 1.0
		
	#wait audio = 6
	
	elif mode == 6:
		#fade out both
		i2.set_self_modulate(Color(1,1,1,timer))
		i3.set_self_modulate(Color(1,1,1,timer))
		timer -= delta
		if timer < 0:
			mode = 7
			timer = 0.0
	
	elif mode == 7:
		i4.set_self_modulate(Color(1,1,1,timer))
		timer+=delta
		if timer > 1:
			mode = 8
			timer = 1.0


func _audio_1_over():
	get_node("audio2").play()
	mode = 1
	pass # Replace with function body.


func _audio_2_over():
	get_node("audio3").play()
	mode = 4
	pass # Replace with function body.

func _audio_3_over():
	get_node("audio4").play()
	mode = 6
	pass

func _audio_4_over():
	get_tree().change_scene_to_packed(simultaneous_scene)
	pass # Replace with function body.
