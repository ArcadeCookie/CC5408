extends "Grabable.gd"

func _ready():
	if DataManager.state.dim_1.test_object.translation != Vector3():
		set_translation(DataManager.state.dim_1.test_object.translation)
		set_rotation(DataManager.state.dim_1.test_object.rotation)
	
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	var SM_terminal = SignalManager.Terminals.DOOR_1
	SignalManager._register_required_object(SM_terminal, self)
	
	SignalManager._add_receiver(Events.CHANGING_MAP, self, "_on_map_change")
	._ready()


func _on_map_change():
	print("executed")
	DataManager.state.dim_1.test_object.translation = get_translation()
	DataManager.state.dim_1.test_object.rotation = get_rotation()
