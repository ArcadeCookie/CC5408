extends RigidBody

# Child nodes references
onready var collision_shape = get_node("CollisionShape")

# Entity variables
signal grabed(node1, node2)

var nteraction_timer = 0
var interaction_threshold = 0.001

var interaction_available = false
var grabed = false

var availability_timer : Timer
var highlight : MeshInstance

# This function set up the node
func _ready():
	var SignalManager = get_parent().get_node("SignalManager")
	var Events = SignalManager.Events
	SignalManager._add_emitter(Events.OBJECT_GRABED, self, "grabed")
	SignalManager._add_receiver(Events.ENABLE_INTERACTION, self, "_on_enable_interaction")
	SignalManager._add_receiver(Events.GRAB_OBJECT, self, "_on_grab")
	SignalManager._add_receiver(Events.DROP_OBJECT, self, "_on_drop")
	
	var og_mesh_instance = get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	add_child(highlight)
	var mesh = og_mesh
	mesh.flip_faces = true
	
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(1,1,0,0.6)
	mat.flags_transparent = true
	mat.flags_unshaded = true
	
	highlight.scale *= 1.1
	highlight.mesh = mesh
	highlight.material_override = mat
	highlight.visible = false
	
	availability_timer = Timer.new()
	availability_timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(availability_timer)
	availability_timer.set_wait_time(0.1)


# response funtion for enable interacion
func _on_enable_interaction(object : Node) -> void:
	if object == self:
		entered()


# response method for being grabed
func _on_grab(object : Node) -> void:
	if interaction_available:
		highlight.visible = false
		collision_shape.disabled = true
		sleeping = true
		self.set_translation(Vector3(0,0,0))
		grabed = true
		emit_signal("grabed", object, self)


# response method for being droped
func _on_drop(object : Node) -> void:
	if grabed and object == self:
		collision_shape.disabled = false
		sleeping = false
		grabed = false
		#self.set_linear_velocity(Vector3(0,0,0))
		#self.set_angular_velocity(Vector3(0,0,0))


# response function for timer duration
func _on_timer_timeout() -> void:
	exited()


func entered() -> void:
	highlight.visible = true
	interaction_available = true
	availability_timer.start()


func exited() -> void:
	highlight.visible = false
	interaction_available = false
	availability_timer.stop()
