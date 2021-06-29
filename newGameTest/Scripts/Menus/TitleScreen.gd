extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	var newgame = $Menu/HBoxContainer/Buttons/NewGameButton
	newgame.connect("pressed", self, "_on_NewGameButton_pressed")
	
#
func _on_NewGameButton_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DataManager.call_HUD("res://Scenes/Map/NewGameIntro.tscn")
	DataManager.remove_HUD(self)
