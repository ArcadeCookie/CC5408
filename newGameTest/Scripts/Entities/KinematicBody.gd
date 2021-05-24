extends KinematicBody

var path = []
var path_node = 0

var speed = 10
var chase_speed = 6

onready var nav = get_parent()
onready var player = $"../../Player"
onready var raycast = $"MeshInstance2/RayCast"
onready var timer = $"Timer"

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
}

var state = IDLE
var on_chase = false

var actual_node = 1

var timer_lock = 0

var actual_direction = Vector3()
var facing_direction = Vector3(0,0,1)
#
## <>
func _ready():
	pass
#
func _physics_process(delta):
	if on_chase:
		timer_lock += delta
	_look_at(actual_direction)
	if seeing_player():
		state = CHASING
		if timer_lock > 0.25:
			move_to(player.global_transform.origin)
			timer_lock = 0
		if not on_chase:
			on_chase = true
			move_to(player.global_transform.origin)
	else:
		if state != IDLE:
			state = OBJECTIVE_LOST
	match state:
		IDLE:
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
				move_to_node()
				state = IDLE
				on_chase = false


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
	if raycast.is_colliding():
		var collider = raycast.get_collider()
		if collider in get_tree().get_nodes_in_group("visible_range"):
			return true
	return false


func _look_at(direction):
	while facing_direction.angle_to(direction) > PI - 0.2:
		print(facing_direction.angle_to(direction))
		direction = direction.rotated(Vector3(0,1,0),0.1)
	var interpolated_direction = facing_direction.normalized().linear_interpolate(direction.normalized(), 0.1).normalized()
	var new_angle = interpolated_direction.angle_to(Vector3(0,0,1))
	if facing_direction.x < 0:
		new_angle = -new_angle
	
	facing_direction = interpolated_direction
	set_rotation(Vector3(0, new_angle, 0))


func _on_Timer_timeout():
	pass
