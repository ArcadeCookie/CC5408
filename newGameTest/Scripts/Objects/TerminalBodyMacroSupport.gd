extends "res://Scripts/Objects/TerminalBody.gd"

# Determine if every terminal conected to it is active at the moment
func is_any_terminal_active() -> bool:
	var any_terminal_is_active = false
	for terminal in terminals:
		any_terminal_is_active = any_terminal_is_active or terminal.is_active
	return any_terminal_is_active


# This function purpose is simply to act as an intermediary between is_every_terminal_active
# and on_activation methods, so its called every time a terminal conected to it is activated
func on_terminal_active() -> void:
	if is_any_terminal_active():
		on_activation()


# OVERRIDE IN SPECIFIC INSTANCE TO CREATE DEDICATED BEHAVIOUR
# every terminal should do an specific thing and that behaviour have to be specified
# on a specific instance of TerminalBody
func on_activation() -> void:
	pass
