extends "res://Scripts/Objects/Terminal.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> Terminal -> Node -> ...


# Exectuted on generation of the instance, giving the object this values for id and req_object_id
func _init():
	id = 6
	req_object_id = -2
	# After this, the object gets instanciated with Terminal._ready()

func on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	is_active = true
	DataManager.State.Terminals[id] = true
	terminal_body.on_terminal_active()
