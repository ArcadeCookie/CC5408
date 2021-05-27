extends "res://Scripts/Entities/Player_NSM.gd"

func change_map():
	DataManager.state.player.translation = get_translation()
	DataManager.state.player.rotation = get_rotation()
	get_tree().change_scene("res://Scenes/Demo/DemoMap1.tscn")
