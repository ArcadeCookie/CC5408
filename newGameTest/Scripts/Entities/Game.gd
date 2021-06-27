extends Node


var current_world: Node = null
var loading = false
var loading_world = ""

onready var fade = $CanvasLayer/Fade

func _ready():
	fade.connect("faded", self, "on_faded")
	current_world = load("res://Scenes/Demo/DemoMap1.tscn").instance()
	$World.add_child(current_world)
	set_process(false)
	ResourceQueue.start()


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
