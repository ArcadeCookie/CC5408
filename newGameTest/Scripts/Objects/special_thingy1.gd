extends "res://Scripts/Objects/SpecialGrabable.gd"
# Specific instance of a SpecialGrabable object
# Hierarchy: This -> SpecialGrabable -> Grabable -> RigidBody -> ...


# Exectuted on generation of the instance, giving the object this values for id and dimension
func _init():
	id = 6
	# Special items will be stored in a specific section 
	dimension = "Special_Objects"
	# After this, the object gets instanciated with Grabable._ready()
