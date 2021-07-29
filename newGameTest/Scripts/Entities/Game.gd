extends Node


var current_world: Node = null
var loading = false
var loading_world = ""

var HUD_on_screen = false

var showing_stamina = false

onready var fade = $CanvasLayer/Fade
onready var stamina_bar = $CanvasLayer/Stamina/ProgressBar
onready var Q_key = $CanvasLayer/Q
onready var E_key = $CanvasLayer/E
onready var nav = $Navigation
onready var world = $Navigation/NavigationMeshInstance/World

func _ready():
	fade.connect("faded", self, "on_faded")
	#current_world = load("res://Scenes/Map/MapaIntro.tscn").instance()
	#current_world = load("res://Scenes/Demo/DemoMap1.tscn").instance()
	#world.add_child(current_world)
	set_process(false)
	ResourceQueue.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	call_HUD("res://Scenes/Menus/MainMenu2.tscn")


func change_scene(scene):
	loading_world = scene
	print(loading_world)
	loading = true
	fade.fade_in()


func on_faded():
	if loading:
		world.remove_child(current_world)
		current_world.queue_free()
		ResourceQueue.queue_resource(loading_world)
		set_process(true)


func _process(delta: float) -> void:
	fade.set_progress(ResourceQueue.get_progress(loading_world))
	if ResourceQueue.is_ready(loading_world):
		var new_world = ResourceQueue.get_resource(loading_world)
		current_world = new_world.instance()
		world.add_child(current_world)
		loading = false
		# linea nueva
		#DataManager.removeScenes()
		fade.fade_out()
		set_process(false)


func call_HUD(scene):
	var s = load(scene).instance()
	$CanvasLayer.add_child(s)


func call_unique_HUD(scene):
	if not HUD_on_screen:
		HUD_on_screen = true
		var s = load(scene).instance()
		$CanvasLayer.add_child(s)


func remove_HUD(scene_node):
	$CanvasLayer.remove_child(scene_node)
	scene_node.queue_free()


func remove_unique_HUD(scene_node):
	$CanvasLayer.remove_child(scene_node)
	scene_node.queue_free()
	HUD_on_screen = false


func removeScenes():
	var nodes = $CanvasLayer.get_children()
	for children in nodes:
		if not children is ColorRect and not children is ViewportContainer:
			$CanvasLayer.remove_child(children)


func player_stop():
	var player = world.get_node("Spatial/Player")
	if player != null:
		player.speed = 0
		player.sprinting_speed = 0


func player_play():
	var player = world.get_node("Spatial/Player")
	if player != null:
		player.speed = 5
		player.sprinting_speed = 10


func update_stamina(val, maximum, going_up):
	if not showing_stamina and not going_up:
		stamina_bar.visible = true
		showing_stamina = true
		stamina_bar.get_node("AnimationPlayer").play("In")
	stamina_bar.anchor_left = 0.49 - 0.3 * val / maximum
	stamina_bar.anchor_right = 0.51 + 0.3 * val / maximum
	if val == maximum and going_up:
		hide_stamina()


func hide_stamina():
	stamina_bar.get_node("AnimationPlayer").play("Fade")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Fade":
		stamina_bar.visible = false
		showing_stamina = false

func changeObjective(objective, boolean):
	$CanvasLayer/Objective/Text.text = objective
	if boolean:
		showObjective()
	
func showObjective():
	$CanvasLayer/Objective/Text/ObjectiveAnim.play("display")


func showKeys():
	Q_key.visible = true
	E_key.visible = true


func hideKeys():
	Q_key.visible = false
	E_key.visible = false

func camera_stop():
	var player = world.get_node("Spatial/Player")
	if player != null:
		player.camera_free = false

func camera_play():
	var player = world.get_node("Spatial/Player")
	if player != null:
		player.camera_free = true


func clean_enemies():
	if nav != null:
		var node = nav.get_node("Enemies")
		for n in node.get_children():
			node.remove_child(n)
			n.queue_free()


func init_enemies(scripts):
	var node = nav.get_node("Enemies")
	for script in scripts:
		var enemy = load("res://Scenes/Entities/EnemyVisual.tscn").instance()
		node.add_child(enemy)
		print(enemy.get_parent().get_parent())
		enemy.set_script(load("res://Scripts/Entities/Enemies/" + script))
		enemy._ready()
		enemy.init()
		print(enemy.interest_nodes)

func load_intro_map():
	#loading_world = "res://Scenes/Map/MapaIntro.tscn"
	loading_world = "res://Scenes/Map/Dimension1.tscn"
	loading = true
	ResourceQueue.queue_resource(loading_world)
	set_process(true)
