extends "res://Scripts/Objects/Terminal.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> Terminal -> Node -> ...

onready var Terminal = get_parent()
# Exectuted on generation of the instance, giving the object this values for id and req_object_id
func _init():
	id = 101
	req_object_id = 101
	# After this, the object gets instanciated with Terminal._ready()

## Override
func on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	var this_id = -1
	if object.has_method("on_grab"):
		this_id = object.id
	if not is_active:
		if this_id == req_object_id:
			is_active = true
			DataManager.State.Terminals[id] = true
			Terminal.item1 = 1
			terminal_body.on_terminal_active()
		elif this_id == -1:
			DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_IncorrectEmpty.tscn")
		else:
			DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_Incorrect.tscn")
