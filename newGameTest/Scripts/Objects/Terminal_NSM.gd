extends Node

# Child nodes references
onready var terminal = get_node("Terminal")

var interaction_available = false
var active = false

var availability_timer : Timer
var highlight : MeshInstance


# This function set up the node
func _ready():
	var og_mesh_instance = get_node("Terminal").get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	terminal.add_child(highlight)
	var mesh = og_mesh.duplicate()
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
func enable_interaction(object : Node) -> void:
	if object == terminal and not active:
		highlight.visible = true
		interaction_available = true
		availability_timer.start()


# response function for timer duration
func _on_timer_timeout() -> void:
	highlight.visible = false
	interaction_available = false
	availability_timer.stop()


# NECESARIO EN INSTANCIA ESPECIFICA
func _on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	active = true
