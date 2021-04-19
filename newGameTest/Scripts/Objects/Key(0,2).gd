extends "Grabable.gd"

func _ready():
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	var SM_terminal = SignalManager.Terminals.DOOR_2
	SignalManager._register_required_object(SM_terminal, self)
	._ready()
