extends Node

# Identifier for every event in-game
enum Events {
			ENABLE_INTERACTION
			GRAB_OBJECT
			}

var emitters = {}
var receivers = {}

# This function will register a new emitter for an event
# with its respective signal and connects with any receiver
# already registered to the same Event
func _add_emitter(Event : int, emitter : Node, signal_name : String) -> void:
	if not emitters.has(Event):
		emitters[Event] = []
	emitters[Event].append([emitter, signal_name])
	if receivers.has(Event):
		for receiver_info in receivers[Event]:
			var receiver = receiver_info[0]
			var receiver_method_name = receiver_info[1]
			emitter.connect(signal_name, receiver, receiver_method_name)

# This function will register a new receiver for an event
# with its respective response method and connects with any emitter
# already registered to the same Event
func _add_receiver(Event : int, receiver : Node, response_method : String) -> void:
	if not receivers.has(Event):
		receivers[Event] = []
	receivers[Event].append([receiver, response_method])
	if emitters.has(Event):
		for emitter_info in emitters[Event]:
			var emitter = emitter_info[0]
			var signal_name = emitter_info[1]
			emitter.connect(signal_name, receiver, response_method)
