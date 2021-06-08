extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var button_var = $Viewport/Control/Numero0
onready var GUI_thing
onready var node_viewport = $Viewport
onready var node_quad = $MeshInstance
onready var node_area = $MeshInstance/Area
signal panel_success

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	# Check if the event is a non-mouse/non-touch event
	if event is InputEventMouseButton:
		node_viewport.input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Control_success():
	emit_signal("panel_success")
