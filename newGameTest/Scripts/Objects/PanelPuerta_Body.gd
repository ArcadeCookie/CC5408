extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...


# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 15 
	# After this, the object gets instanciated with TerminalBody._ready()


# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	DataManager.call_unique_HUD("res://Scenes/GUI/Dimension1/PanelPuerta.tscn")
	DataManager.player_stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _openDoor():
	var rot = Vector3()
	var transl = Vector3()
	rot.x = 0
	rot.y = -95
	rot.z = 0
	transl.x = 1.527
	transl.y = 0.0
	transl.z = 1.352
	$Door/Tween.interpolate_property($Door, "rotation_degrees", $Door.rotation_degrees, rot, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Door/Tween.interpolate_property($Door, "translation", $Door.translation, transl, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Door/Tween.start()
	$Door/Sound.play()
