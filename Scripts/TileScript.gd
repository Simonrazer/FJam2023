extends Node3D
var be : Material = preload("res://Prefabs/be.tres")
var we : Material = preload("res://Prefabs/we.tres")
var bf : Material = preload("res://Prefabs/bf.tres")
var wf : Material = preload("res://Prefabs/wf.tres")
var b_ : Material = preload("res://Prefabs/b_.tres")
var w_ : Material = preload("res://Prefabs/w_.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass

#type: w/b|e/f/_
func init(type: String):

	var col:Color
	if type[0] == "w":
		if type[1] == "e":
			get_node("MeshInstance3D").set_material_override(we)
		elif type[1] == "f":
			get_node("MeshInstance3D").set_material_override(wf)
		elif type[1] == "_":
			get_node("MeshInstance3D").set_material_override(w_)
	elif type[0] == "b":
		if type[1] == "e":
			get_node("MeshInstance3D").set_material_override(be)
		elif type[1] == "f":
			get_node("MeshInstance3D").set_material_override(bf)
		elif type[1] == "_":
			get_node("MeshInstance3D").set_material_override(b_)

