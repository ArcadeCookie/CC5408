extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_Exit_pressed():
	DataManager.remove_HUD(self)
