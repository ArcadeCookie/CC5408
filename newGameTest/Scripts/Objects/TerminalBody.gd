extends Node 

# Variables to valuate on specific instances
var id          # Give identity to the instance and help name and identify its terminals
var terminals   # Store every terminal that is conected with it

func _ready() -> void:
	var group_name = "terminal" + String(id)
	terminals = get_tree().get_nodes_in_group(group_name)
	on_terminal_active()


# Determine if every terminal conected to it is active at the moment
func is_every_terminal_active() -> bool:
	var all_terminals_are_active = true
	for terminal in terminals:
		all_terminals_are_active = all_terminals_are_active and terminal.is_active
	return all_terminals_are_active


# This function purpose is simply to act as an intermediary between is_every_terminal_active
# and on_activation methods, so its called every time a terminal conected to it is activated
func on_terminal_active() -> void:
	if is_every_terminal_active():
		on_activation()


# OVERRIDE IN SPECIFIC INSTANCE TO CREATE DEDICATED BEHAVIOUR
# every terminal should do an specific thing and that behaviour have to be specified
# on a specific instance of TerminalBody
func on_activation() -> void:
	pass
