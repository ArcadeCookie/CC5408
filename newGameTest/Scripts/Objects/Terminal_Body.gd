extends Node 

var id
var terminals = []

func _ready():
	var group_name = "terminal" + String(id)
	terminals = get_tree().get_nodes_in_group(group_name)
	on_terminal_active()


func is_every_terminal_active():
	var all_terminals_are_active = true
	for terminal in terminals:
		all_terminals_are_active = all_terminals_are_active and terminal.is_active
	return all_terminals_are_active


func on_terminal_active():
	if is_every_terminal_active():
		on_activation()


# OVERRIDE IN SPECIFIC INSTANCE TO CREATE DEDICATED BEHAVIOUR
func on_activation():
	pass
