extends RigidBody

# Child nodes references
onready var collision_shape = get_node("CollisionShape")

# Variables to valuate on specific instances
var id          # Give identity to the instance and help a terminal and the DataManager to identify it 
var dimension   # Store the dimension in wich it should be, making the DataManager able to locate it

var interaction_available = false
var grabed = false

var availability_timer : Timer
var highlight : MeshInstance


# This function set up the node
func _ready() -> void:
	can_sleep = false
	
	add_to_group("object")
	
	set_collision_layer(4)
	
	var og_mesh_instance = get_node("MeshInstance")
	og_mesh_instance.set_layer_mask(2)
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	highlight.set_layer_mask(4)
	highlight.set_scale($MeshInstance.get_scale())
	add_child(highlight)
	var mesh = og_mesh.duplicate()
	#mesh.flip_faces = true
	
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(1,1,0,0.03)
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
	
	if not DataManager.State[dimension].has(id):
		DataManager.State[dimension][id] = {"translation" : get_translation(), "rotation"  : get_rotation()}
	set_translation(DataManager.State[dimension][id].translation)
	set_rotation(DataManager.State[dimension][id].rotation)


# response funtion for enable interacion
func enable_interaction(object : Node) -> void:
	if object == self:
		highlight.visible = true
		interaction_available = true
		availability_timer.start()


# response method for being grabed
func on_grab(player : Node, hand : Node) -> void:
	if interaction_available:
		highlight.visible = false
		collision_shape.disabled = true
		self.set_translation(Vector3(0,0,0))
		grabed = true
		player.on_grabed_object(hand, self)


# response method for being droped
func on_drop(object : Node) -> void:
	if grabed and object == self:
		collision_shape.disabled = false
		grabed = false


func _on_timer_timeout() -> void:
	highlight.visible = false
	interaction_available = false


# Method that manages the world change behaviour
func on_change_map() -> void:
	DataManager.State[dimension][id].translation = get_translation()
	DataManager.State[dimension][id].rotation = get_rotation()


func _process(delta):
	var pos = get_translation()
	if pos.y < 0.01:
		pos.y = 0.05
		set_translation(pos)
