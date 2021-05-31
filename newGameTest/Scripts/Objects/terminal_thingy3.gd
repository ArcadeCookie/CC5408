extends "res://Scripts/Objects/Terminal.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> Terminal -> Node -> ...


# Exectuted on generation of the instance, giving the object this values for id and req_object_id
func _init():
	id = 3
	req_object_id = 0
	# After this, the object gets instanciated with Terminal._ready()
