extends KinematicBody

var path = []
var path_node = 0

var speed = 0
var chase_speed = 0

onready var nav = get_parent()
onready var player = $"../../Player"
onready var dynamic_raycast_node = $"RayCast"
onready var dynamic_raycast = $"RayCast/RayCast"
onready var interest_nodes = [
	$"../Interest_Point_1",
	$"../Interest_Point_2",
	$"../Interest_Point_3",
	$"../Interest_Point_4",
	$"../Interest_Point_5",
	$"../Interest_Point_6",
	$"../Interest_Point_7",
	$"../Interest_Point_8",
	$"../Interest_Point_9"
]

## REFERENCIAS A BORRAR ##
onready var bar1 = $"Bar1"
onready var bar2 = $"Bar2"
onready var vision_pointer = $"RayCast/MeshInstance"
onready var hearing_area = $"CloseArea"
onready var vision_area = $"Vision/Area"
onready var vision_marker_1 = $"Vision/Spatial/MeshInstance2"
onready var vision_marker_2 = $"Vision/Spatial2/MeshInstance2"
onready var vision_marker_1_node = $"Vision/Spatial"
onready var vision_marker_2_node = $"Vision/Spatial2"
onready var grin_hearing_marker = $"Bar1/MeshInstance"
onready var penk_hearing_marker = $"Bar2/MeshInstance"
##########################

## ENVIROnMENTAL VARIABLES ##
var vision_range = 30
var vision_angle = PI/8
var vision_dot
var hearing_range = 10
var hearing_factor = 1
#############################


var nodes_relations = {
	0 : [1,3],
	1 : [0,4],
	2 : [5],
	3 : [0,4],
	4 : [1,3,5,7],
	5 : [2,4],
	6 : [7],
	7 : [4,6,8],
	8 : [7]
}

enum {
	IDLE
	CHASING
	OBJECTIVE_LOST
	SEARCHING
}

var state = IDLE
var on_chase = false

var actual_node = 1

var timer_lock_on = 0

var actual_direction = Vector3()
var facing_direction = Vector3(0,0,1)

var before_searching = Vector3()
var search_direction = 0
var look_state = 0

var calm_rotation = 0.05
var agresive_rotation = 0.12
var search_depth = 4*PI/5



func _ready():
	vision_pointer.get_mesh().mid_height = vision_range
	vision_pointer.set_translation(Vector3(0,0,vision_range/2))
	vision_marker_1.get_mesh().mid_height = vision_range
	vision_marker_1.set_translation(Vector3(0,0,vision_range/2))
	vision_marker_2.get_mesh().mid_height = vision_range
	vision_marker_2.set_translation(Vector3(0,0,vision_range/2))
	vision_marker_1_node.set_rotation(Vector3(0,vision_angle,0))
	vision_marker_2_node.set_rotation(Vector3(0,-vision_angle,0))
	vision_area.get_mesh().top_radius = vision_range
	vision_area.get_mesh().bottom_radius = vision_range
	hearing_area.get_mesh().top_radius = hearing_range
	hearing_area.get_mesh().bottom_radius = hearing_range
	grin_hearing_marker.get_mesh().mid_height = hearing_range
	grin_hearing_marker.set_translation(Vector3(0,0,hearing_range/2))
	penk_hearing_marker.get_mesh().mid_height = hearing_range
	penk_hearing_marker.set_translation(Vector3(0,0,hearing_range/2))
	vision_dot = facing_direction.dot(facing_direction.rotated(Vector3(0,1,0), vision_angle))
	print(vision_dot)


func _physics_process(delta):
	# PROCESS STIMULI
	_look_at(actual_direction)
	if on_chase:
		timer_lock_on += delta
	if seeing_player():
		if timer_lock_on > 0.1:
			move_to(player.global_transform.origin)
			timer_lock_on = 0
		if not on_chase:
			state = CHASING
			on_chase = true
			move_to(player.global_transform.origin)
	else:
		if state == CHASING:
			state = OBJECTIVE_LOST
	
	# ENEMY MOVES AS ITS STATE DICTATES
	match state:
		# APARENTLY IDLE IS DONE
		IDLE:
			if facing_direction.angle_to(actual_direction) < PI/8:
				if path_node < path.size():
					var direction = (path[path_node] - global_transform.origin)
					actual_direction = direction
					if direction.length() < 1:
						path_node += 1
					else:
						move_and_slide(direction.normalized() * speed, Vector3.UP)
				else:
					move_to_node()
		CHASING:
			if path_node < path.size():
				var direction = (path[path_node] - global_transform.origin)
				actual_direction = direction
				if direction.length() < 1:
					path_node += 1
				else:
					move_and_slide(direction.normalized() * chase_speed, Vector3.UP)
			else:
				move_to(player.global_transform.origin)
		OBJECTIVE_LOST:
			if path_node < path.size():
				var direction = (path[path_node] - global_transform.origin)
				actual_direction = direction
				if direction.length() < 1:
					path_node += 1
				else:
					move_and_slide(direction.normalized() * chase_speed, Vector3.UP)
			else:
				state = SEARCHING
				# DEBE IRSE
				#move_to_node()
				#state = IDLE
				on_chase = false
				look_state = 1
		SEARCHING:
			match look_state:
				1:
					var rng = RandomNumberGenerator.new()
					rng.randomize()
					search_direction = sign(rng.randf_range(-1,1))
					before_searching = facing_direction
					actual_direction = facing_direction.rotated(Vector3(0,1,0), search_depth * search_direction)
					look_state = 2
				2: 
					if facing_direction.angle_to(actual_direction) < PI/32:
						actual_direction = before_searching
						look_state = 3
				3:
					if facing_direction.angle_to(actual_direction) < PI/8:
						var og_angle = before_searching
						actual_direction = og_angle.rotated(Vector3(0,1,0), search_depth * -search_direction)
						look_state = 4
				4:
					if facing_direction.angle_to(actual_direction) < PI/32:
						actual_direction = before_searching
						look_state = 5
				5:
					if facing_direction.angle_to(actual_direction) < PI/8:
						state = IDLE
						move_to_node()


func move_to(target_pos):
	path = nav.get_simple_path(global_transform.origin, target_pos)
	path_node = 1


func move_to_node():
	var nodes = nodes_relations[actual_node]
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randi_range(0, nodes.size() - 1)
	var node_index = nodes[number]
	actual_node = node_index
	move_to(interest_nodes[node_index].get_translation())


func seeing_player():
	var player_pos = player.get_translation()
	var player_2d = Vector2(player_pos.x, player_pos.z)
	var self_pos = get_translation()
	var self_2d = Vector2(self_pos.x, self_pos.z)
	var distance = self_2d.distance_to(player_2d)
	var dot = clamp(-1 + 2 * distance / (hearing_range * 4), -1, 1)
	var angle = acos(dot)
	bar1.set_rotation(Vector3(0,angle,0))
	bar2.set_rotation(Vector3(0,-angle,0))
	var to_player = self_2d.direction_to(player_2d)
	var facing_2d = Vector2(facing_direction.x, facing_direction.z)
	var angle_to_player = facing_2d.angle_to(to_player)
	var try_vector = facing_2d.rotated(angle_to_player).normalized()
	if try_vector.is_equal_approx (to_player):
		dynamic_raycast_node.set_rotation(Vector3(0,-angle_to_player,0))
	
	if dynamic_raycast.is_colliding():
		var collision = dynamic_raycast.get_collider()
		if collision == player:
			var player_dot = facing_2d.dot(to_player)
			if player_dot > 0.5:
				return true
			if player_dot > dot:
				return true
	return false


func _look_at(direction):
	var factor
	if state == CHASING or state == SEARCHING:
		factor = agresive_rotation
	else:
		factor = calm_rotation
	while facing_direction.angle_to(direction) > PI - 0.2:
		direction = direction.rotated(Vector3(0,1,0),0.1)
	var interpolated_direction = facing_direction.normalized().linear_interpolate(direction.normalized(), factor).normalized()
	var new_angle = interpolated_direction.angle_to(Vector3(0,0,1))
	if facing_direction.x < 0:
		new_angle = -new_angle
	facing_direction = interpolated_direction
	set_rotation(Vector3(0, new_angle, 0))
