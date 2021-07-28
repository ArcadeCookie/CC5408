extends "res://Scripts/Objects/Grabable.gd"
# Specific instance of a Grabable object
# Hierarchy: This -> Grabable -> RigidBody -> ...


# Exectuted on generation of the instance, giving the object this values for id and dimension
func _init():
	id = 300
	dimension = "D1"
	# After this, the object gets instanciated with Grabable._ready()
