extends Node

onready var terminal_body = get_parent()

var id
var req_object_id

var is_active = false

var availability_timer : Timer
var highlight : MeshInstance

func _ready():
	var og_mesh_instance = get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	add_child(highlight)
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
	
	var group_name = "terminal" + String(terminal_body.id)
	add_to_group(group_name)
	if not DataManager.State.Terminals.has(id):
		DataManager.State.Terminals[id] = false
	if DataManager.State.Terminals[id]:
		force_on_terminal_interaction()


func enable_interaction(object : Node) -> void:
	if object == self and not is_active:
		highlight.visible = true
		availability_timer.start()


func _on_timer_timeout() -> void:
	highlight.visible = false
	availability_timer.stop()


func force_on_terminal_interaction():
	is_active = true
	DataManager.State.Terminals[id] = true


# OVERRIDE IN SPECIFIC INSTANCE TO CREATE DEDICATED BEHAVIOUR UPON TERMINAL ACTIVATION
func on_terminal_interaction(terminal_node : Node, object : Node) -> void:
	if object.id == req_object_id and not is_active:
		is_active = true
		DataManager.State.Terminals[id] = true
		terminal_body.on_terminal_active()
