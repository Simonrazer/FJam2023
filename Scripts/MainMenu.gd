extends Node2D
var simultaneous_scene = preload("res://Maps/PreMission1.tscn")
var tx: TextureRect
var px: TextureRect
# Called when the node enters the scene tree for the first time.
func _ready():
	tx = get_node("CanvasLayer/TextureRect")
	px = get_node("CanvasLayer/TextureRect2")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var goNext = false
var timer1 = 1.0
var timer2 = 1.0

var mode = -1
func _process(delta):
	if Input.is_action_just_released("ui_accept"):
		mode = 0
	if mode == 0:
		px.set_self_modulate(Color(timer2, timer2, timer2, 1.0))
		timer2 -= delta*0.5
		if timer2 < 0:
			mode = 1
	
	elif mode == 1:
		px.set_self_modulate(Color(0, 0, 0, 1-timer2))
		timer2 += delta*0.5
		if timer2 > 1:
			mode = 2
	
	if goNext:
		tx.set_self_modulate(Color(timer1, timer1, timer1, 1.0))
		timer1 -= delta*0.5
		if timer1 < 0:
			get_tree().change_scene_to_packed(simultaneous_scene)
	pass


func _on_btn_start_button_up():
	goNext = true
	pass # Replace with function body.

