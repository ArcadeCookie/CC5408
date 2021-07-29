extends "res://Scripts/Objects/Terminal.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> Terminal -> Node -> ...

# Exectuted on generation of the instance, giving the object this values for id and req_object_id
func _init():
	id = 17
	req_object_id = 1
	# After this, the object gets instanciated with Terminal._ready()

## Override
## Avisa de que no hay tarjeta
func on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	var this_id = -1
	if object.has_method("on_grab"):
		this_id = object.id
	if this_id == req_object_id and not is_active:
		is_active = true
		DataManager.State.Terminals[id] = true
		terminal_body.on_terminal_active()
		var hand = object.get_parent()
		var camera = hand.get_parent()
		var player = camera.get_parent()
		if hand==player.right_hand:
			for element in player.viewport_rh.get_children():
				element.queue_free()
		else:
			for element in player.viewport_lh.get_children():
				element.queue_free()
		object.queue_free()
	else:
		DataManager.call_unique_HUD("res://Scenes/GUI/PC_Oficina_No.tscn")
