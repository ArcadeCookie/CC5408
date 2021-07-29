extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...
var item1
var item2
var item3
var screwdriver

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 100
	item1 = 0
	item2 = 0
	item3 = 0
	screwdriver = 0
	# After this, the object gets instanciated with TerminalBody._ready()


# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	var world = get_parent()
	world.get_node("Tubo1").show()
	#DataManager.call_unique_HUD("res://Scenes/GUI/LabMixer/LabMixer_Create.tscn")
