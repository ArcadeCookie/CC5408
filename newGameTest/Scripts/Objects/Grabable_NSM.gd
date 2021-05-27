extends RigidBody

# Child nodes references
onready var collision_shape = get_node("CollisionShape")

var interaction_available = false
var grabed = false
var on_floor = true

var availability_timer : Timer
var sleep_timer : Timer
var highlight : MeshInstance

var test_timer = 0
var reg_linear_velocity = Vector3()
var reg_angular_velocity = Vector3()
var vector = Vector3(0.00000001,0.000000001,0.000000001)
# This function set up the node
func _ready():
	set_mode(MODE_STATIC) 
	
	var og_mesh_instance = get_node("MeshInstance")
	var og_mesh = og_mesh_instance.mesh
	
	highlight = MeshInstance.new()
	add_child(highlight)
	var mesh = og_mesh.duplicate()
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
	availability_timer.set_wait_time(0.01)
	
	sleep_timer = Timer.new()
	sleep_timer.connect("timeout",self,"_on_sleep_timer_timeout") 
	add_child(sleep_timer)
	sleep_timer.set_wait_time(0.5)


# response funtion for enable interacion
func enable_interaction(object : Node) -> void:
	if object == self:
		highlight.visible = true
		interaction_available = true
		availability_timer.start()


# response method for being grabed
func _on_grab(player : Node, hand : Node) -> void:
	if interaction_available:
		highlight.visible = false
		collision_shape.disabled = true
		sleeping = true
		self.set_translation(Vector3(0,0,0))
		grabed = true
		player.on_grabed_object(hand, self)


# response method for being droped
func _on_drop(object : Node) -> void:
	if grabed and object == self:
		collision_shape.disabled = false
		sleeping = false
		grabed = false
		set_mode(MODE_RIGID)
		sleep_timer.start()


# response function for timer duration
func _on_timer_timeout() -> void:
	highlight.visible = false
	interaction_available = false
	availability_timer.stop()


func _on_sleep_timer_timeout():
	on_floor = false
	reg_linear_velocity = linear_velocity
	reg_angular_velocity = angular_velocity
	sleep_timer.stop()


func _physics_process(delta):
	if not on_floor:
		test_timer += delta
		if test_timer >= 0.5:
			test_timer = 0
			if linear_velocity <= vector and angular_velocity <= vector:
				print("done")
				set_mode(MODE_STATIC)
				on_floor = true
