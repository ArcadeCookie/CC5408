extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...


# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 16
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	DataManager.call_unique_HUD("res://Scenes/GUI/PanelCajaFuerte.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#var world = get_parent()
	#world.get_node("KinematicBody2").disable_mouse()

func _openSafe():
	$Terminal.opened = true
	$Terminal.deactivate()
	var rot = Vector3()
	var transl = Vector3()
	# init  35.345        11.905   rot.y -90.0
	# final 35.396  -0.008 13.076   rot.y 10.0
	rot.x = self.rotation_degrees.x
	rot.y = self.rotation_degrees.y + 100.0
	rot.z = self.rotation_degrees.z
	transl.x = self.translation.x + 0.051
	transl.y = self.translation.y
	transl.z = self.translation.z + 1.171
	$Terminal/Tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, rot, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.interpolate_property(self, "translation", self.translation, transl, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.start()
	$Terminal/Sound.play()
	DataManager.call_unique_HUD("res://Scenes/GUI/CajaFuerteAbierta.tscn")
