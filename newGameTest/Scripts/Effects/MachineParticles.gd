extends RigidBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var Bola := $Particles4
onready var Bola2 := $Particles5
onready var Minutero := $Timer
var tiempo

# Called when the node enters the scene tree for the first time.
func _ready():
	self.tiempo = 0

func iniciar():
	Minutero.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	if tiempo <= 40:		
		Bola.scale.x = Bola.scale.x + 0.125
		Bola.scale.y = Bola.scale.y + 0.125
		Bola.scale.z = Bola.scale.z + 0.125
		#Bola.translation.z = Bola.translation.z - 0.0125
		iniciar()
	elif (40 < tiempo) and (tiempo <= 100):
		Bola.scale.x = Bola.scale.x + 0.25
		Bola.scale.y = Bola.scale.y + 0.25
		Bola.scale.z = Bola.scale.z + 0.25
		Bola2.scale.x = Bola2.scale.x + 0.25
		Bola2.scale.y = Bola2.scale.y + 0.25
		Bola2.scale.z = Bola2.scale.z + 0.25
		#Bola2.translation.z = Bola2.translation.z - 0.05
		Bola.translation.z = Bola.translation.z - 0.05
		iniciar()
	elif (150 < tiempo):
		iniciar()
	else:
		Bola.scale.x = Bola.scale.x + 0.3
		Bola.scale.y = Bola.scale.y + 0.3
		Bola.scale.z = Bola.scale.z + 0.3
		Bola2.scale.x = Bola2.scale.x + 0.3
		Bola2.scale.y = Bola2.scale.y + 0.3
		Bola2.scale.z = Bola2.scale.z + 0.3
		#Bola2.translation.z = Bola2.translation.z - 0.075
		Bola.translation.z = Bola.translation.z - 0.075
		iniciar()
	self.tiempo += 1

func _on_KinematicBody_startExpl():
	iniciar()
