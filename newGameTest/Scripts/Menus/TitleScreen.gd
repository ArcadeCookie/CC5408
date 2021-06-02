extends Control

onready var _transition_rect := $FadeIn

# Called when the node enters the scene tree for the first time.
func _ready():
	#pass
	var newgame = $Menu/HBoxContainer/Buttons/NewGameButton
	newgame.connect("pressed", self, "_on_NewGameButton_pressed")
#
#func newGame_pressed():
#	$FadeIn.show()
#	$FadeIn.fade_in()
#
#func newGame():
#	scene_path_to_load = "res://Scenes/Demo/DemoMapaFinal"
#	get_tree().change_scene(scene_path_to_load)
#
func _on_NewGameButton_pressed():
	_transition_rect.transition_to("res://Scenes/Demo/DemoMap1.tscn")
	#$FadeIn.fade_in()
	#get_tree().change_scene("res://Scenes/Demo/DemoMapaFinal.tscn")
	#pass # Replace with function body.
	
