extends RigidBody

# entity variables
var interaction_timer = 0
var interaction_threshold = 0.5

var interaction_available = false

var availability_timer
var highlight

func _ready():
	highlight = MeshInstance.new()
	add_child(highlight)
	var mesh = SphereMesh.new()
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


func _on_timer_timeout():
	exited()


func entered():
	highlight.visible = true
	interaction_available = true
	availability_timer.start()


func exited():
	highlight.visible = false
	interaction_available = false
	availability_timer.stop()
