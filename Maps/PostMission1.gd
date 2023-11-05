extends Node2D
var simultaneous_scene = preload("res://Maps/Shop.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_1_finished():
	print("osndf")
	get_tree().change_scene_to_packed(simultaneous_scene)
	pass # Replace with function body.
