extends "res://Scripts/Objects/Terminal.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> Terminal -> Node -> ...

onready var Terminal = get_parent()
var first_time
var screwdriver

# Exectuted on generation of the instance, giving the object this values for id and req_object_id
func _init():
	id = 104
	req_object_id = 104 #screwdriver
	first_time = 0
	screwdriver = 0
	# After this, the object gets instanciated with Terminal._ready()

# Override
func on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	var this_id = -1
	if object.has_method("on_grab"):
		this_id = object.id
	if first_time == 0 and Terminal.item1 != 1 and Terminal.item2 != 1 and Terminal.item3 != 1:
		DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_1st.tscn")
		first_time = 1
	elif Terminal.item1 != 1 and Terminal.item2 != 1 and Terminal.item3 != 1 :
		DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_Missing.tscn")
	elif Terminal.item1 == 1 and Terminal.item2 == 1 and Terminal.item3 == 1 and screwdriver == 0:
		DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_MixFail.tscn")
		screwdriver = 1
	elif this_id == req_object_id:
		is_active = true
		DataManager.State.Terminals[id] = true
		terminal_body.on_terminal_active()
		#is_active = false
		#DataManager.State.Terminals[id] = false
		# should happen to have it after going to dim2
	elif screwdriver == 1:
		DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_FixRequired.tscn")
