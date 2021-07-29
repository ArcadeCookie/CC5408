extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...
#onready var Puerta = $Terminal
var status # 0 closed , 1 open

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 202
	status = 0
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	if status == 0:
		_openDoor()
	else:
		_closeDoor()

func _openDoor():
	var rot = Vector3()
	var transl = Vector3()
	rot.x = self.rotation_degrees.x
	rot.y = self.rotation_degrees.y +90
	rot.z = self.rotation_degrees.z
	transl.x = self.translation.x + 0.549
	transl.y = self.translation.y
	transl.z = self.translation.z + 0.527
	$Terminal/Tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, rot, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.interpolate_property(self, "translation", self.translation, transl, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.start()
	$Terminal/Sound.play()
	$Terminal/Timer.start()
	status = 1

func _closeDoor():
	var rot = Vector3()
	var transl = Vector3()
	rot.x = self.rotation_degrees.x
	rot.y = self.rotation_degrees.y - 90
	rot.z = self.rotation_degrees.z
	transl.x = self.translation.x - 0.549
	transl.y = self.translation.y
	transl.z = self.translation.z - 0.527
	$Terminal/Tween.interpolate_property(self, "rotation_degrees", self.rotation_degrees, rot, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.interpolate_property(self, "translation", self.translation, transl, 0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Terminal/Tween.start()
	$Terminal/Sound.play()
	$Terminal/Timer.start()
	status = 0


func _on_Timer_timeout():
	$Terminal.reactivate()
