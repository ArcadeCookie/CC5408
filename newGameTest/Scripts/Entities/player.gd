extends KinematicBody

onready var camera = get_node("Camera")

var speed = 3
var gravity = -9.8
var mouse_sensitivity = 0.2
var sprinting = false
var sprinting_speed = 10

# amount of stamina, expresed in seconds
var stamina = 3
var max_stamina = 3
var resting = true
var rest_timer = 0
var rest_time_threshold = 2

var crouching = false

var direction = Vector3()
var velocity = Vector3()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
# This standard function manages events 
# V0.0.1: its managing mouse rotation
# :return null:
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -90, 90)
	direction = Vector3()
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)


# This funtion will return the movement vector based on the camera horizontal angle
# and will manage the input_map
# :return: Vector3
func get_input():
	var cam_direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		cam_direction += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		cam_direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		cam_direction += -camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		cam_direction += camera.global_transform.basis.x
	if Input.is_action_just_pressed("sprint"):
		sprinting = true
		resting = false
		rest_timer = 0
	if Input.is_action_just_released("sprint"):
		sprinting = false
	if Input.is_action_just_pressed("crouch"):
		crouching = true
	if Input.is_action_just_released("crouch"):
		crouching = false
	cam_direction = cam_direction.normalized()
	return cam_direction

# Standard function that executes fixed amount of times per frame
# :param delta: float time since last frame
# :return null:
func _physics_process(delta):
	var objective_velocity = Vector3()
	
	# gravity force
	velocity.y += gravity * delta
	print (stamina)
	# instant velocity to desired direction
	if sprinting:
		objective_velocity = get_input() * sprinting_speed
		stamina -= delta
		if stamina <= 0:
			sprinting = false
	else:
		objective_velocity = get_input() * speed
		rest_timer += delta
		if resting:
			stamina = clamp(stamina + delta/2, 0, max_stamina)
		elif rest_timer >= 3:
			resting = true
		
	velocity.x = objective_velocity.x
	velocity.z = objective_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)
