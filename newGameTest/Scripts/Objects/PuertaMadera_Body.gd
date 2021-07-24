extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...
onready var DoorTween = $Terminal/Tween

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 22
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	$Terminal.rotation_degrees.y = -90
	$Terminal.translation.x = 0.549
	$Terminal.translation.z = 0.527
