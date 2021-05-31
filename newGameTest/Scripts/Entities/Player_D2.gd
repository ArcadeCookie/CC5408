extends "res://Scripts/Entities/Player.gd"
# Specific instance of a Player object
# Hierarchy: This -> Player -> KineticBody -> ...


# Overriden method so this specific instance has desired behaviour
# REVIEWING DELETION
func change_map():
	.change_map()
	DataManager.State.Player.translation = get_translation()
	DataManager.State.Player.rotation = get_rotation()
	get_tree().change_scene("res://Scenes/Demo/DemoMap3.tscn")
