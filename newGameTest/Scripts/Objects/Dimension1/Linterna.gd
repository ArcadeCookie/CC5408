extends "res://Scripts/Objects/Grabable.gd"
# Specific instance of a Grabable object
# Hierarchy: This -> Grabable -> RigidBody -> ...


# Exectuted on generation of the instance, giving the object this values for id and dimension
func _init():
	id = 999
	dimension = "D1"
	# After this, the object gets instanciated with Grabable._ready()

func on_grab(player : Node, hand : Node) -> void:
	if interaction_available:
		highlight.visible = false
		collision_shape.disabled = true
		self.set_translation(Vector3(0,0,0))
		grabed = true
		player.on_grabed_object(hand, self)
