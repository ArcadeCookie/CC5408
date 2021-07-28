extends "res://Scripts/Objects/TerminalBodyMacroSupport.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...
onready var Left = $Left
onready var Right = $Right
var status # 0 closed , 1 opened

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 24
	status = 0
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	if status==0:
		_openDoor()
	else:
		_closeDoor()

func _openDoor():
	var transl_Left = Vector3()
	var transl_Right = Vector3()
	transl_Left.z = -1.2
	transl_Right.z = 2.4
	$Left/Tween.interpolate_property(Left, "translation", Left.translation, transl_Left, 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Right/Tween.interpolate_property(Right, "translation", Right.translation, transl_Right, 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Left/Tween.start()
	$Right/Tween.start()
	$Sound.play()
	status = 1

func _closeDoor():
	var transl_Left = Vector3()
	var transl_Right = Vector3()
	transl_Left.z = 0
	transl_Right.z = 1.2
	$Left/Tween.interpolate_property(Left, "translation", Left.translation, transl_Left, 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Right/Tween.interpolate_property(Right, "translation", Right.translation, transl_Right, 0.6, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Left/Tween.start()
	$Right/Tween.start()
	$Sound.play()
	status = 0
