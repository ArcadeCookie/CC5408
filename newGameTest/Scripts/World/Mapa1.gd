extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Music1 := $AudioStreamPlayer
onready var Mundo := $WorldEnvironment
onready var Music2 := $AudioStreamPlayer2

# Called when the node enters the scene tree for the first time.
func _ready():
	Music1.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KinematicBody_change_ambience():
	Mundo.environment.ambient_light_color = 000000
	Music1.stop()
	Music2.play()


func _on_Control_done():
	var text_control = $Control
	text_control.hide()
	text_control.queue_free()
