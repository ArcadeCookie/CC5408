extends Node


func _ready():
	connect("finished", AudioManager, "on_fx_finished", [self])
