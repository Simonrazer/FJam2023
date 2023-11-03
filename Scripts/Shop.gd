extends Node2D

var itemScene = preload("res://Prefabs/Item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var instance = itemScene.instantiate()
	add_child(instance)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
