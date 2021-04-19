extends Node

# Child nodes references
onready var terminal = get_node("Terminal")

# Entity variables
signal interaction_available(node)

var interaction_available = false

var availability_timer : Timer
var highlight : MeshInstance
# NECESARIO EN INSTANCIA ESPECIFICA
var SM_terminal : int


# This function set up the node
func _ready():
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	
	SignalManager._add_emitter(Events.TERMINAL_INTERACTION_AVAILABLE, self, "interaction_available")
	SignalManager._add_receiver(Events.ENABLE_INTERACTION, self, "_on_enable_interaction")
	SignalManager._add_receiver(Events.TERMINAL_INTERACTION, self, "_on_terminal_interaction")
	
	var og_mesh_instance = get_node("Terminal").get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	terminal.add_child(highlight)
	var mesh = og_mesh
	mesh.flip_faces = true
	
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(1,1,1,0.6)
	mat.flags_transparent = true
	mat.flags_unshaded = true
	
	highlight.scale *= 1.1
	highlight.mesh = mesh
	highlight.material_override = mat
	highlight.visible = false
	
	availability_timer = Timer.new()
	availability_timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(availability_timer)
	availability_timer.set_wait_time(0.01)


# response funtion for enable interacion
func _on_enable_interaction(object : Node) -> void:
	if object == terminal:
		entered()


# response function for timer duration
func _on_timer_timeout() -> void:
	exited()


#
func entered() -> void:
	highlight.visible = true
	interaction_available = true
	availability_timer.start()
	emit_signal("interaction_available", self)


# 
func exited() -> void:
	highlight.visible = false
	interaction_available = false
	availability_timer.stop()


# NECESARIO EN INSTANCIA ESPECIFICA
func _on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	if interaction_available and terminal == terminal_node:
		var SignalManager = get_parent().get_node("SignalManager")
		var required_object = SignalManager.required_objects[SM_terminal]
		if object == required_object:
			print("OMG action")
