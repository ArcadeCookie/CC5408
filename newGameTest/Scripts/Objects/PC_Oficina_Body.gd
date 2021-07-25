extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 23
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	#DataManager.removeScenes()
	DataManager.call_unique_HUD("res://Scenes/GUI/PC_Oficina.tscn")
	$StaticBody/Sound.play()
	DataManager.player_stop()
