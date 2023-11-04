class_name Tile extends Node3D
var be : Material = preload("res://Prefabs/be.tres")
var we : Material = preload("res://Prefabs/we.tres")
var bf : Material = preload("res://Prefabs/bf.tres")
var wf : Material = preload("res://Prefabs/wf.tres")
var b_ : Material = preload("res://Prefabs/b_.tres")
var w_ : Material = preload("res://Prefabs/w_.tres")

var blu : Material = preload("res://Prefabs/blueHigh.tres")

var game_controller: GameController

var color: String
# Called when the node enters the scene tree for the first time.
func _ready():
	#rando = RandomNumberGenerator.new().randi()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_game_controller(gc: GameController):
	game_controller = gc

#type: w/b|e/f/_
func set_color(type: String):
	color = type
	if type[0] == "w":
		if type[1] == "e":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(we)
		elif type[1] == "f":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(wf)
		elif type[1] == "_":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(w_)
	elif type[0] == "b":
		if type[1] == "e":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(be)
		elif type[1] == "f":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(bf)
		elif type[1] == "_":
			get_node("StaticBody3D/MeshInstance3D").set_material_override(b_)

func reset_color():
	set_color(color)

func highlight():
	get_node("StaticBody3D/MeshInstance3D").set_material_override(blu)

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if Input.is_action_just_pressed("click"):
		game_controller.change_state(GameController.ChangeTrigger.Tile, Vector2(self.position.x, self.position.z))
	pass # Replace with function body.
