extends "res://Scripts/Objects/Terminal_Body.gd"


func _init():
	id = 2


func on_activation():
	var right = get_node("Right")
	var left = get_node("Left")
	right.set_translation(right.get_translation() + Vector3(0,0,2))
	left.set_translation(left.get_translation() + Vector3(0,0,-2))
