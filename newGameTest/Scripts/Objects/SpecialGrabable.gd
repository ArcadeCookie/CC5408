extends "res://Scripts/Objects/Grabable.gd"
# Extends from a grabable Object, still not an instanciable "class"

var time = 0
var og_scale

# Set the properties that a special grabable should have
# Before this method execution a Grabable._ready() method will happen
func _ready() -> void:
	var mat = highlight.get_material_override()
	mat.albedo_color = Color(1,0,0,0.6)
	highlight.scale *= 1.1
	og_scale = highlight.scale


# Method with a fixed execution
# Just make the highlight a little bit more apealing
func _physics_process(delta : float) -> void:
	time += delta * 5
	var dimension = 1 + 0.04 * sin(time)
	highlight.scale = og_scale * dimension
