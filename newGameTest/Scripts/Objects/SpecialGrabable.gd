extends "Grabable.gd"

var og_map = true

var time = 0

var fading_out = false
var fading_in = false
var fade = 0

# Standard method for handling key events
func _unhandled_key_input(event):
	if Input.is_action_just_pressed("scene_change"):
		fading_out = true


# 
func _ready():
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	var SM_terminal = SignalManager.Terminals.DOOR_3
	
	SignalManager._add_emitter(Events.OBJECT_GRABED, self, "grabed")
	SignalManager._add_receiver(Events.ENABLE_INTERACTION, self, "_on_enable_interaction")
	SignalManager._add_receiver(Events.GRAB_OBJECT, self, "_on_grab")
	SignalManager._add_receiver(Events.DROP_OBJECT, self, "_on_drop")
	
	SignalManager._register_required_object(SM_terminal, self)
	
	var og_mesh_instance = get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	add_child(highlight)
	var mesh = og_mesh.duplicate()
	mesh.flip_faces = true
	
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(1,0,0,0.6)
	mat.flags_transparent = true
	mat.flags_unshaded = true
	
	highlight.scale *= 1.2
	highlight.mesh = mesh
	highlight.material_override = mat
	highlight.visible = false
	
	availability_timer = Timer.new()
	availability_timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(availability_timer)
	availability_timer.set_wait_time(0.01)


#
func _physics_process(delta):
	time += delta * 5
	var dimension = 1.2 + 0.15 * sin(time)
	highlight.scale = Vector3(dimension,dimension,dimension)
	
	if fading_out:
		fade += delta
		var token = sin(fade)
		if token > 1-0.001:
			fading_in = true
			change_map()
		if token < 0 + 0.001:
			token = 0
			fade = 0
			fading_in = false
			fading_out = false

#
func change_map() -> void:
	if og_map:
		set_translation(Vector3(80,0,0) + get_translation())
		og_map = false
	else:
		set_translation(Vector3(-80,0,0) + get_translation())
		og_map = true
