extends KinematicBody


onready var camera = get_node("Camera")
onready var world = get_parent()
onready var GUI1 := $Camera/Spatial
onready var luz := $Camera/SpotLight

var gravity = -50

var mouse_sensitivity = 0.2
var speed = 5
var sprinting_speed = 10
var stamina = 3
var max_stamina = 3
var rest_timer = 0
var rest_time_threshold = 2
var rest_factor = 0.5
var fade = 0

var sprinting = false
var resting = true
var crouching = false
var interaction_available = false
var og_map = true
var fading_out = false
var fading_in = false

var availability_timer : Timer
var direction = Vector3()
var velocity = Vector3()

# nuevo del menu
var menu_opened = false
signal change_ambience


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func get_input() -> Vector3:
	var cam_direction = Vector3()
	if menu_opened==true:
		return cam_direction
	if Input.is_action_pressed("move_forward"):
		cam_direction += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		cam_direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		cam_direction += -camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		cam_direction += camera.global_transform.basis.x
	cam_direction.y = 0
	cam_direction = cam_direction.normalized()
	return cam_direction
	
func _unhandled_input(event):
	if menu_opened==true:
		return 
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -80, 80)
	direction = Vector3()
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)

# Standard method for handling key events
func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("open_gui"):
		GUI1.show()
		menu_opened = true
		luz.light_energy = 0
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		

func _physics_process(delta):
	var objective_velocity = Vector3()
	
	# gravity force
	velocity.y += gravity * delta
	# instant velocity to desired direction
	if sprinting:
		objective_velocity = get_input() * sprinting_speed
		stamina -= delta
		if stamina <= 0:
			sprinting = false
	else:
		objective_velocity = get_input() * speed
		if resting:
			stamina = clamp(stamina + delta * rest_factor, 0, max_stamina)
		elif rest_timer >= rest_time_threshold:
			resting = true
		else:
			rest_timer += delta
		
	velocity.x = objective_velocity.x
	velocity.z = objective_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)


func _on_Spatial_panel_success():
	menu_opened = false
	luz.light_energy = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	emit_signal("change_ambience")
	GUI1.hide()
	
