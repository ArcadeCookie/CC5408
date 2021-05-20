extends Button

export(String) var scene_to_load

#func _on_NewGameButton_pressed():
#	pass
	#get_tree().change_scene("res://Scenes/Demo/DemoMapaFinal.tscn")


func NewGameChange():
	get_tree().change_scene("res://Scenes/Demo/DemoMapaFinal.tscn")
