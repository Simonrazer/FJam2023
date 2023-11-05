extends Node2D

var textNode: RichTextLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	textNode = get_node("CanvasLayer/ItemDesc")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_item_1_gui_input(event):
	textNode.text = "Rüstung +2"

	pass # Replace with function body.


func _on_item_2_gui_input(event):
	textNode.text = "Angreifen 3 Felder quer"
	pass # Replace with function body.


func _on_item_3_gui_input(event):
	textNode.text = " Lebenspunkte +2"
	pass # Replace with function body.


func _on_item_4_gui_input(event):
	textNode.text = "Lebensraub +1 Heilung"
	pass # Replace with function body.


func _on_item_5_gui_input(event):
	textNode.text = "Angreifen +2 Reichweite"
	pass # Replace with function body.


func _on_item_6_gui_input(event):
	textNode.text = "Angreifen +1 Schaden"
	pass # Replace with function body.


func _on_item_7_gui_inputd(event):
	textNode.text = "Heilen +1 Heilung"
	pass # Replace with function body.


func _on_item_8_gui_input(event):
	textNode.text = "Bewegung +2"
	pass # Replace with function body.


func _on_item_7_gui_input(event):
	pass # Replace with function body.
