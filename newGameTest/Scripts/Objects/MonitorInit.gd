extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...
signal activateMenu


# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 0 
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	#var right = get_node("CSGBox")
	#var left = get_node("Left")
	#right.set_translation(right.get_translation() + Vector3(0,0,2))
	#left.set_translation(left.get_translation() + Vector3(0,0,-2))
	emit_signal("activateMenu")
	#DataManager.disable_dimension("1")
