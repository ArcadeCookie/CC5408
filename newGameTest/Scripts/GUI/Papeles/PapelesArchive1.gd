extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DataManager.remove_HUD(self)
