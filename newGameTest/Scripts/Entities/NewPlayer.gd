extends KinematicBody

# child nodes references
# (posible referenciation: onready var camera = $"Camera")
onready var camera = get_node("Camera")
onready var raycast = camera.get_node("RayCast")
onready var right_hand = camera.get_node("RightHand")
onready var left_hand = camera.get_node("LeftHand")
onready var drop_node = camera.get_node("Drop")
onready var sub_viewport = get_parent().get_parent().get_parent().get_node("CanvasLayer/ViewportContainer/Viewport")
onready var viewport_rh = sub_viewport.get_node("Camera/RightHand")
onready var viewport_lh = sub_viewport.get_node("Camera/LeftHand")

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
	#if Input.is_action_just_pressed("ui_select"):
	#	$Camera/ScreenShaker._wakeup()
	if Input.is_action_just_pressed("sprint"):
		is_sprinting = true
		is_resting = false
		rest_timer = 0
	if Input.is_action_just_released("sprint"):
		is_sprinting = false
	if Input.is_action_just_pressed("crouch"):
		is_crouching = true
		crouch()
	if Input.is_action_just_released("crouch"):
		is_crouching = false
		crouch()
	if Input.is_action_just_pressed("right_action"):
		hand_action(right_hand)
	if Input.is_action_just_pressed("left_action"):
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
	var phantom_object = object.duplicate()
	object.visible = false
	phantom_object.set_angular_velocity(Vector3(0,0,0))
	phantom_object.set_linear_velocity(Vector3(0,0,0))
	phantom_object.set_mode(1)
	if hand == right_hand:
		viewport_rh.add_child(phantom_object)
	else:
		viewport_lh.add_child(phantom_object)
	phantom_object.set_translation(Vector3(0,0,0))


func drop_object(hand : Node) -> void:
	var object = hand.get_child(0)
	var position = camera.to_global(drop_node.get_translation())
	var drop_pos = camera.to_global(drop_node.get_translation())
	var cam_pos = self.to_global(camera.get_translation())
	object.set_translation(cam_pos - Vector3(0, 0.1, 0))
	hand.remove_child(object)
	world.add_child(object)
	
	object.visible = true
	if hand == right_hand:
		var phantom_object = viewport_rh.get_child(0)
		phantom_object.queue_free()
	else:
		var phantom_object = viewport_lh.get_child(0)
		phantom_object.queue_free()
	object.set_linear_velocity(2 * (drop_pos - cam_pos))
	object.on_drop(object)


# This method determine what action to make on an action key being pressed
func hand_action(hand : Node) -> void:
	if hand.get_child_count() == 0:
	# Have no object grabed on hand node
		if raycast.is_colliding():
			var collision = raycast.get_collider()
			if collision.has_method("on_grab"):
				collision.on_grab(self, hand)
			if collision.has_method("on_terminal_interaction"):
				collision.on_terminal_interaction(collision, self)
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


func crouch():
	var cam_pos = camera.get_translation()
	var collision_shape = $CollisionShape
	var collision_shape2 = $CollisionShape2
	if is_crouching:
		collision_shape.disabled = false
		collision_shape2.disabled = true
		cam_pos.y = -0.2
	else:
		collision_shape.disabled = true
		collision_shape2.disabled = false
		cam_pos.y = 0.8
	camera.set_translation(cam_pos)


# OVERRIDE TO SPECIFIC INSTANCE BEHAVIOUR
func change_map() -> void:
	DataManager.State.Player.translation = get_translation()
	DataManager.State.Player.rotation = get_rotation()
	DataManager.change_map()

func changespeed(val) -> void:
	speed = 5*val
	sprinting_speed = 10*val
