extends Node


var current_world: Node = null
var loading = false
var loading_world = ""

onready var fade = $CanvasLayer/Fade

func _ready():
	fade.connect("faded", self, "on_faded")
	current_world = load("res://Scenes/Map/Mapa1text.tscn").instance()
	#current_world = load("res://Scenes/Demo/DemoMap1.tscn").instance()
	$World.add_child(current_world)
	set_process(false)
	ResourceQueue.start()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	call_HUD("res://Scenes/Menus/MainMenu2.tscn")


func change_scene(scene):
	loading_world = scene
	loading = true
	fade.fade_in()


func on_faded():
	if loading:
		$World.remove_child(current_world)
		current_world.queue_free()
		ResourceQueue.queue_resource(loading_world)
		set_process(true)


func _process(delta: float) -> void:
	fade.set_progress(ResourceQueue.get_progress(loading_world))
	if ResourceQueue.is_ready(loading_world):
		var new_world = ResourceQueue.get_resource(loading_world)
		current_world = new_world.instance()
		$World.add_child(current_world)
		loading = false
		fade.fade_out()
		set_process(false)


func call_HUD(scene):
	var s = load(scene).instance()
	$CanvasLayer.add_child(s)


func remove_HUD(scene_node):
	$CanvasLayer.remove_child(scene_node)
	scene_node.queue_free()

## testing

func send_signal(sig):
	current_world.signalR(sig)

func testremove():
	var something = $CanvasLayer.get_children()
	for children in something:
		if not children is ColorRect:
			$CanvasLayer.remove_child(children)
