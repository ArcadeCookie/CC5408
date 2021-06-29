extends KinematicBody

# child nodes references
# (posible referenciation: onready var camera = $"Camera")
onready var camera = get_node("Camera")
onready var raycast = camera.get_node("RayCast")
onready var right_hand = camera.get_node("RightHand")
onready var left_hand = camera.get_node("LeftHand")

# parent nodes reference
onready var world = get_parent()

var mouse_sensitivity = 0.2
var speed = 5
var sprinting_speed = 10
var stamina = 3
var max_stamina = 3
var rest_timer = 0
var rest_time_threshold = 2
var rest_factor = 0.5
var fade = 0

var is_sprinting = false
var is_resting = true
var is_crouching = false

var direction = Vector3()
var velocity = Vector3()


# This method set up the node
func _ready() -> void:
	if not DataManager.State.Player.empty():
		set_translation(DataManager.State.Player.translation)
		set_rotation(DataManager.State.Player.rotation)
	
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
func _unhandled_input(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x - event.relative.y * mouse_sensitivity, -80, 80)
	direction = Vector3()
	direction = direction.normalized().rotated(Vector3.UP, rotation.y)


# Standard method for handling key events
func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("sprint"):
		is_sprinting = true
		is_resting = false
		rest_timer = 0
	if Input.is_action_just_released("sprint"):
		is_sprinting = false
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		var pos = get_translation()
		pos.y = 0
		set_translation(pos)
		var collision_shape = $CollisionShape
		collision_shape.set_translation(Vector3(0,1.5,0))
	if Input.is_action_just_released("crouch"):
		is_crouching = false
		var pos = get_translation()
		pos.y = 1
		set_translation(pos)
		var collision_shape = $CollisionShape
		collision_shape.set_translation(Vector3(0,0.5,0))
	if Input.is_action_just_pressed("right_action"):
		hand_action(right_hand)
	if Input.is_action_just_pressed("left_action"):
		DataManager.call_HUD("res://Scenes/GUI/IntroTextCtrl.tscn")
		hand_action(left_hand)
	if Input.is_action_just_pressed("scene_change"):
		if right_hand.get_child_count() > 0:
			drop_object(right_hand)
		if left_hand.get_child_count() > 0:
			drop_object(left_hand)
		change_map()


# Standard function that executes fixed amount of times per frame
func _physics_process(delta : float) -> void:
	var objective_velocity = Vector3()
	
	# instant velocity to desired direction
	if is_sprinting:
		objective_velocity = get_input() * sprinting_speed
		stamina -= delta
		if stamina <= 0:
			is_sprinting = false
	else:
		objective_velocity = get_input() * speed
		if is_resting:
			stamina = clamp(stamina + delta * rest_factor, 0, max_stamina)
		elif rest_timer >= rest_time_threshold:
			is_resting = true
		else:
			rest_timer += delta
	if is_crouching:
		objective_velocity *= 0.4
	velocity.x = objective_velocity.x
	velocity.y = 0
	velocity.z = objective_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)


# Standard function that executes fixed amount of times per frame
func _process(delta : float) -> void:
	if raycast.is_colliding():
		var collision = raycast.get_collider()
		if collision.has_method("enable_interaction"):
			collision.enable_interaction(collision)


# Response method to a grabed object
func on_grabed_object(hand : Node, object : Node) -> void:
	world.remove_child(object)
	hand.add_child(object)


# Method to drop an object and once again include it in the world
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
	object.on_drop(object)


# This method determine what action to make on an action key being pressed
func hand_action(hand : Node) -> void:
	if hand.get_child_count() == 0:
	# Have no object grabed on hand node
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.has_method("on_grab"):
				collision.on_grab(self, hand)
	else:
	# Have an object grabed on hand node
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.has_method("on_terminal_interaction"):
				var object = hand.get_child(0)
				collision.on_terminal_interaction(collision, object)
			else:
				drop_object(hand)
		else:
				drop_object(hand)


# OVERRIDE TO SPECIFIC INSTANCE BEHAVIOUR
func change_map() -> void:
	DataManager.State.Player.translation = get_translation()
	DataManager.State.Player.rotation = get_rotation()
	DataManager.change_map()

