extends "res://Scripts/Objects/Grabable.gd"

var time = 0

func _ready():
	var mat = highlight.get_material_override()
	mat.albedo_color = Color(1,0,0,0.6)
	highlight.scale *= 1.2


func _physics_process(delta):
	time += delta * 5
	var dimension = 1.2 + 0.15 * sin(time)
	highlight.scale = Vector3(dimension,dimension,dimension)
