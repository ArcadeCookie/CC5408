extends "Terminal.gd"

func _ready():
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	
	SM_terminal = SignalManager.Terminals.DOOR_0
	
	SignalManager._register_terminal(SM_terminal, self)
	._ready()
	if DataManager.state.terminals.test_door:
		_force_terminal_interaction()

func _on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	if interaction_available and terminal == terminal_node:
		var SignalManager = get_parent().get_node("SignalManager")
		var required_object = SignalManager.required_objects[SM_terminal]
		if object == required_object:
			DataManager.state.terminals.test_door = true
			var right = get_node("Right")
			var left = get_node("Left")
			right.set_translation(right.get_translation() + Vector3(0,0,2))
			left.set_translation(left.get_translation() + Vector3(0,0,-2))
			._on_terminal_interaction(terminal_node, object)


func _force_terminal_interaction():
	var right = get_node("Right")
	var left = get_node("Left")
	right.set_translation(right.get_translation() + Vector3(0,0,2))
	left.set_translation(left.get_translation() + Vector3(0,0,-2))
	._on_terminal_interaction(self, self)
