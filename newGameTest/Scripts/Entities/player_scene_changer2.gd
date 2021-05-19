extends KinematicBody

# child nodes references
onready var camera = get_node("Camera")
onready var raycast = camera.get_node("RayCast")
onready var right_hand = camera.get_node("RightHand")
onready var left_hand = camera.get_node("LeftHand")
onready var cap = camera.get_node("Cap")

# parent nodes reference
onready var world = get_parent()

# Signal Manager references
var SignalManager
var Events

# enviroment variables
var gravity = -50

# entity variables
signal enable_interaction(object)
signal grab_object(node)
signal drop_object(object)
signal terminal_interaction(node, object)
signal changing_map

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
var related_terminal = null


# This method set up the node
func _ready():
	if DataManager.state.player.translation != Vector3():
		set_translation(DataManager.state.player.translation)
		set_rotation(DataManager.state.player.rotation)
	
	SignalManager = world.get_node("SignalManager")
	Events = SignalManager.Events
	
	SignalManager._add_emitter(Events.ENABLE_INTERACTION, self, "enable_interaction")
	SignalManager._add_emitter(Events.GRAB_OBJECT, self, "grab_object")
	SignalManager._add_emitter(Events.DROP_OBJECT, self, "drop_object")
	SignalManager._add_emitter(Events.TERMINAL_INTERACTION, self, "terminal_interaction")
	SignalManager._add_receiver(Events.OBJECT_GRABED, self, "_on_grabed_object")
	SignalManager._add_receiver(Events.TERMINAL_INTERACTION_AVAILABLE, self, "_on_interaction_available")
	
	SignalManager._add_emitter(Events.CHANGING_MAP, self, "changing_map")
	
	availability_timer = Timer.new()
	availability_timer.connect("timeout",self,"_on_timer_timeout") 
	add_child(availability_timer)
	availability_timer.set_wait_time(0.01)
	
	# Center and hide the cursor
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
	cam_direction.y = 0
	cam_direction = cam_direction.normalized()
	return cam_direction


# Standard method for handling events
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -80, 80)
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
		hand_action(right_hand)
	if Input.is_action_just_pressed("left_action"):
		hand_action(left_hand)
	if Input.is_action_just_pressed("scene_change"):
		if right_hand.get_child_count() > 0:
			drop_object(right_hand)
		if left_hand.get_child_count() > 0:
			drop_object(left_hand)
		fading_out = true


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
		cap.get_surface_material(0).set_albedo(Color(0,0,0,token))


# Standard function that executes fixed amount of times per frame
func _process(_delta):
	if raycast.is_colliding():
		var collision = raycast.get_collider()
		emit_signal("enable_interaction", collision)


# response method to a grabed object
func _on_grabed_object(hand : Node, object : Node) -> void:
	world.remove_child(object)
	hand.add_child(object)


# Manages grabing an object REVIEWING DELETION
func grab_with(hand : Node) -> void:
	if hand.get_child_count() == 0:
		emit_signal("grab_object",hand)
	else:
		var object = hand.get_child(0)
		var position = \
		  camera.to_global(right_hand.get_translation())*0.5 \
		+ camera.to_global(left_hand.get_translation())*0.5
		object.set_linear_velocity(Vector3())
		object.set_angular_velocity(Vector3())
		object.set_translation(position)
		hand.remove_child(object)
		world.add_child(object)
		emit_signal("drop_object", object)


#
func drop_object(hand : Node) -> void:
	var object = hand.get_child(0)
	var position = \
			camera.to_global(right_hand.get_translation())*0.5 \
			+ camera.to_global(left_hand.get_translation())*0.5
	object.set_linear_velocity(Vector3())
	object.set_angular_velocity(Vector3())
	object.set_translation(position)
	hand.remove_child(object)
	world.add_child(object)
	emit_signal("drop_object", object)


#
func hand_action(hand : Node) -> void:
	if hand.get_child_count() == 0:
		emit_signal("grab_object",hand)
	else:
		if interaction_available:
			var object = hand.get_child(0)
			emit_signal("terminal_interaction", related_terminal, object)
		else:
			drop_object(hand)


#
func _on_interaction_available(terminal : Node) -> void:
	interaction_available = true
	availability_timer.start()
	related_terminal = terminal.get_node("Terminal")


#
func _on_timer_timeout() -> void:
	interaction_available = false
	availability_timer.stop()
	related_terminal = null


#
func change_map() -> void:
	emit_signal("changing_map")
	DataManager.state.player.translation = get_translation()
	DataManager.state.player.rotation = get_rotation()
	get_tree().change_scene("res://Scenes/Demo/DemoMap1.tscn")
