extends RayCast

func _ready():
	set_process(true)

func _process(delta):
	if is_colliding():
		var obj = get_collider()
		if obj.is_in_group("grabable"):
			obj.entered()
