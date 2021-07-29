extends KinematicBody

var path = []
var path_node = 0
var speed = 3.2
var chase_speed = 7.3

onready var nav = $"../.."
onready var world = $"../../NavigationMeshInstance/World"
onready var dynamic_raycast_node = $"RayCast"
onready var dynamic_raycast = $"RayCast/RayCast"
onready var body = $"Sombra6"
onready var spawn_particles = $"Particles"
var interest_nodes
var nodes_relations
var spawn_timer
var inner_clock = 0


## ENVIROnMENTAL VARIABLES ##
var vision_range = 20
var vision_angle = PI/4
var vision_dot
var hearing_range = 10
var hearing_factor = 1
var is_angry = false
#############################


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

var actual_direction = Vector2()
var facing_direction = Vector2(0,1)

var before_searching = Vector2()
var search_direction = 0
var look_state = 0

var calm_rotation = 0.02
var agresive_rotation = 0.1
var search_depth = 4*PI/5



func _ready():
	set_process(false)
	vision_dot = facing_direction.dot(facing_direction.rotated(vision_angle))
	dynamic_raycast.set_scale(Vector3(1,1,vision_range))
	$"Sombra6/Pasivo".play("CaminarPasivo")


func _physics_process(delta):
	# CHECK STIMULI
	_look_at(actual_direction)
	if on_chase:
		timer_lock_on += delta
	if seeing_player():
		if not is_angry:
			is_angry = true
			swap_anim()
		if timer_lock_on > 0.05:
			var player = world.get_node("Spatial/Player")
			move_to(player.global_transform.origin)
			timer_lock_on = 0
		if not on_chase:
			var player = world.get_node("Spatial/Player")
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
			#body.get_active_material(0).albedo_color = Color(1,1,1)
			if abs(facing_direction.angle_to(actual_direction)) < PI/8:
				if path_node < path.size():
					var direction = (path[path_node] - global_transform.origin)
					if direction.length() < 1:
						path_node += 1
					else:
						direction = direction.normalized()
						actual_direction = Vector2(direction.x, direction.z).normalized()
						move_and_slide(Vector3(actual_direction.x, 0, actual_direction.y) * speed, Vector3.UP)
				else:
					move_to_node()
		CHASING:
			#body.get_active_material(0).albedo_color = Color(1,0,0)
			var player = world.get_node("Spatial/Player")
			if path_node < path.size():
				var direction = (path[path_node] - global_transform.origin)
				actual_direction = Vector2(direction.x, direction.z).normalized()
				if direction.length() < 1:
					path_node += 1
				else:
					move_and_slide(Vector3(actual_direction.x, 0, actual_direction.y) * chase_speed, Vector3.UP)
			else:
				move_to(player.global_transform.origin)
		OBJECTIVE_LOST:
			#body.get_active_material(0).albedo_color = Color(1,0.5,0)
			if path_node < path.size():
				var direction = (path[path_node] - global_transform.origin)
				actual_direction = Vector2(direction.x, direction.z).normalized()
				if direction.length() < 1:
					path_node += 1
				else:
					move_and_slide(Vector3(actual_direction.x, 0, actual_direction.y) * chase_speed, Vector3.UP)
			else:
				state = SEARCHING
				# DEBE IRSE
				#move_to_node()
				#state = IDLE
				on_chase = false
				look_state = 1
		SEARCHING:
			#body.get_active_material(0).albedo_color = Color(1,1,0)
			match look_state:
				1:
					var rng = RandomNumberGenerator.new()
					rng.randomize()
					search_direction = sign(rng.randf_range(-1,1))
					before_searching = facing_direction
					actual_direction = facing_direction.rotated(search_depth * search_direction)
					look_state = 2
				2: 
					if abs(facing_direction.angle_to(actual_direction)) < PI/32:
						actual_direction = before_searching
						look_state = 3
				3:
					if abs(facing_direction.angle_to(actual_direction)) < PI/8:
						var og_angle = before_searching
						actual_direction = og_angle.rotated(search_depth * -search_direction)
						look_state = 4
				4:
					if abs(facing_direction.angle_to(actual_direction)) < PI/32:
						actual_direction = before_searching
						look_state = 5
				5:
					if abs(facing_direction.angle_to(actual_direction)) < PI/32:
						state = IDLE
						if is_angry:
							is_angry = false
							swap_anim()
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
	var player = world.get_node("Spatial/Player")
	var player_pos = player.get_translation()
	var player_2d = Vector2(player_pos.x, player_pos.z)
	var self_pos = get_translation()
	var self_2d = Vector2(self_pos.x, self_pos.z)
	var distance = self_2d.distance_to(player_2d)
	var dot = clamp(-2 + 2 * distance / (hearing_range * 1.2), -1, 1)
	var angle = acos(dot)
	var to_player = self_2d.direction_to(player_2d)
	var facing_2d = Vector2(facing_direction.x, facing_direction.y)
	var angle_to_player = facing_2d.angle_to(to_player)
	var try_vector = facing_2d.rotated(angle_to_player).normalized()
	if try_vector.is_equal_approx (to_player):
		dynamic_raycast_node.set_rotation(Vector3(0,-angle_to_player,0))
	
	if dynamic_raycast.is_colliding():
		var collision = dynamic_raycast.get_collider()
		if collision == player:
			var player_dot = facing_2d.dot(to_player)
			if player_dot > vision_dot:
				return true
			if player_dot > dot and distance <= hearing_range:
				return true
	return false


func _look_at(direction):
	var factor
	if state == CHASING or state == SEARCHING:
		factor = agresive_rotation
	else:
		factor = calm_rotation
	while abs(facing_direction.angle_to(direction)) > PI - 0.2:
		direction = direction.rotated(0.2)
	var interpolated_direction = facing_direction.linear_interpolate(direction, factor).normalized()
	var new_angle = interpolated_direction.angle_to(Vector2(0,1))
	facing_direction = interpolated_direction
	set_rotation(Vector3(0, new_angle, 0))

func swap_anim():
	if is_angry:
		$"Sombra6/Armature/Skeleton2".show()
		$"Sombra6/Armature/Skeleton".hide()
		$"Sombra6/Pasivo".stop()
		$"Sombra6/Angy".play("CaminarPasivo")
		$"Idle".stop()
		$"Chase".play()
	else:
		$"Sombra6/Armature/Skeleton".show()
		$"Sombra6/Armature/Skeleton2".hide()
		$"Sombra6/Angy".stop()
		$"Sombra6/Pasivo".play("CaminarPasivo")
		$"Idle".play()
		$"Chase".stop()


func set_routes():
	var i = 0
	var indexes = []
	while i < interest_nodes.size():
		interest_nodes[i] = nav.get_node("InterestPoints/" + str(interest_nodes[i]))
		indexes.append(i)
		i += 1
	i = 0
	while i < interest_nodes.size():
		nodes_relations[i] = indexes
		i += 1


func init():
	$"Sombra6/Armature/Skeleton2".hide()
	$"Sombra6/Armature/Skeleton".hide()
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var number = rng.randi_range(0, interest_nodes.size() - 1)
	var node = interest_nodes[number]
	var node_pos = self.to_global(node.get_translation())
	node_pos.y = 1.5 
	set_translation(node_pos)
	spawn_timer = rng.randi_range(10, 15)
	spawn_particles.show()
	set_process(true)
	#set_physics_process(true)


func _process(delta):
	inner_clock += delta
	if inner_clock >= spawn_timer:
		set_process(false)
		set_physics_process(true)
		spawn_particles.set_emitting(false)
		$"Sombra6/Armature/Skeleton".show()
	var factor = (spawn_timer - inner_clock) / spawn_timer
	spawn_particles.set_amount(300 * (1 - factor))
	spawn_particles.set_lifetime(3)
	spawn_particles.draw_pass_1.set_size(Vector2(1 - factor, 1 - factor))
	spawn_particles.get_process_material().set_emission_sphere_radius(0.6 * (1 - factor))
