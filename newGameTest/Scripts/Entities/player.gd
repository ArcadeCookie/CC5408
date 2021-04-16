extends KinematicBody

# child nodes references
onready var camera = get_node("Camera")
onready var raycast = camera.get_node("RayCast")
onready var right_hand = get_node("RightHand")
onready var left_hand = get_node("LeftHand")

# parent nodes reference
onready var world = get_parent()

# Signal Manager references
var SignalManager
var Events

# enviroment variables
var gravity = -9.8

# entity variables
signal enable_interaction(object)
signal grab(node)
signal drop

var mouse_sensitivity = 0.2
var speed = 3
var sprinting_speed = 10
var stamina = 3
var max_stamina = 3
var rest_timer = 0
var rest_time_threshold = 2
var rest_factor = 0.5

var sprinting = false
var resting = true
var crouching = false

var direction = Vector3()
var velocity = Vector3()


# This method set up the node
func _ready():
	SignalManager = world.get_node("SignalManager")
	Events = SignalManager.Events
	SignalManager._add_emitter(Events.ENABLE_INTERACTION, self, "enable_interaction")
	SignalManager._add_emitter(Events.GRAB_OBJECT, self, "grab")
	SignalManager._add_emitter(Events.DROP_OBJECT, self, "drop")
	SignalManager._add_receiver(Events.OBJECT_GRABED, self, "_on_grabed_object")
	# Center and hide mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)


# This method will return the movement vector based on the camera horizontal angle
func get_input() -> Vector3:
	var cam_direction = Vector3()
	if Input.is_action_pressed("move_forward"):
		cam_direction += -camera.global_transform.basis.z
	if Input.is_action_pressed("move_back"):
		cam_direction += camera.global_transform.basis.z
	if Input.is_action_pressed("move_left"):
		cam_direction += -camera.global_transform.basis.x
	if Input.is_action_pressed("move_right"):
		cam_direction += camera.global_transform.basis.x
	cam_direction = cam_direction.normalized()
	return cam_direction


# Standard method for handling events
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -90, 90)
	direction = Vector3()
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)


# Standard method for handling key events
func _unhandled_key_input(event):
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
	if Input.is_action_just_pressed("right_action"):
		grab_with(right_hand)
	if Input.is_action_just_pressed("left_action"):
		grab_with(left_hand)

# Standard function that executes fixed amount of times per frame
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


# Standard function that executes fixed amount of times per frame
func _process(_delta):
	if raycast.is_colliding():
		var obj = raycast.get_collider()
		emit_signal("enable_interaction", obj)

# response method to a grabed object
func _on_grabed_object(hand : Node, object : Node) -> void:
	world.remove_child(object)
	hand.add_child(object)

# Manages grabing an object
func grab_with(hand : Node) -> void:
	if hand.get_child_count() == 0:
		emit_signal("grab",hand)
	else:
		var object = hand.get_child(0)
		object.set_translation(hand.get_translation() + self.get_translation())
		hand.remove_child(object)
		world.add_child(object)
		emit_signal("drop")
