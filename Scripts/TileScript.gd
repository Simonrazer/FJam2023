class_name Tile extends Node3D

var we : Material = preload("res://Prefabs/we.tres")
var wf : Material = preload("res://Prefabs/wf.tres")
var b_ : Material = preload("res://Prefabs/b_.tres")
var w_ : Material = preload("res://Prefabs/w_.tres")

var blu : Material = preload("res://Prefabs/blueHigh.tres")

var game_controller: GameController

var color: String
# Called when the node enters the scene tree for the first time.
func initChild():
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
			get_node("kasten/Cube").set_material_override(we)
		elif type[1] == "f":
			get_node("kasten/Cube").set_material_override(wf)
		elif type[1] == "_":
			get_node("kasten/Cube").set_material_override(b_)
	elif type[0] == "b":
		if type[1] == "e":
			get_node("kasten/Cube").set_material_override(we)
		elif type[1] == "f":
			get_node("kasten/Cube").set_material_override(wf)
		elif type[1] == "_":
			get_node("kasten/Cube").set_material_override(b_)

func change_color(type: String):
	color[1] = type[0]
	set_color(color)

func reset_color():
	set_color(color)

func highlight():
	get_node("kasten/Cube").set_material_override(blu)
	
func set_lists(en:Array[CharacterBase],pl:Array[CharacterBase]):
	e = en
	p = pl

var e:Array[CharacterBase]
var p:Array[CharacterBase]

func _on_static_body_3d_input_event(camera, event, position, normal, shape_idx):
	if Input.is_action_just_pressed("click"):
		game_controller.change_state(GameController.ChangeTrigger.Tile, Vector2(self.position.x, self.position.z))
		var current_selected_character
		for c in e:
			if c.position_on_map.x == self.position.x and c.position_on_map.y == self.position.z:
				current_selected_character = c
		for c in p:
			if c.position_on_map.x == self.position.x and c.position_on_map.y == self.position.z:
				current_selected_character = c

		if current_selected_character != null:
			get_parent().get_node("UI/CanvasLayer/Label").text = "Health: "+str(current_selected_character.health)+"/"+str(current_selected_character.base_health)+"\nArmor: "+str(current_selected_character.armor)+"/"+str(current_selected_character.base_armor)+"\nSchaden: "+str(current_selected_character.damage)+"\nRange: "+str(current_selected_character.damage_range)
		else:
			print(Vector2(self.position.x, self.position.z))
