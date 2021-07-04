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
	if tiempo <= 50:		
		Bola.scale.x = Bola.scale.x + 0.08
		Bola.scale.y = Bola.scale.y + 0.08
		Bola.scale.z = Bola.scale.z + 0.08
		#Bola.translation.z = Bola.translation.z - 0.0125
		iniciar()
	elif (50 < tiempo) and (tiempo <= 80):
		Bola.scale.x = Bola.scale.x + 0.24
		Bola.scale.y = Bola.scale.y + 0.24
		Bola.scale.z = Bola.scale.z + 0.24
		Bola2.scale.x = Bola2.scale.x + 0.08
		Bola2.scale.y = Bola2.scale.y + 0.08
		Bola2.scale.z = Bola2.scale.z + 0.08
		#Bola2.translation.z = Bola2.translation.z - 0.05
		Bola.translation.z = Bola.translation.z - 0.05
		iniciar()
	elif (110 < tiempo):
		#iniciar()
		DataManager.call_HUD("res://Scenes/Map/White.tscn")
		# aca deberia ir escena a blanco
	else:
		Bola.scale.x = Bola.scale.x + 0.36
		Bola.scale.y = Bola.scale.y + 0.36
		Bola.scale.z = Bola.scale.z + 0.36
		Bola2.scale.x = Bola2.scale.x + 0.12
		Bola2.scale.y = Bola2.scale.y + 0.12
		Bola2.scale.z = Bola2.scale.z + 0.12
		#Bola2.translation.z = Bola2.translation.z - 0.075
		Bola.translation.z = Bola.translation.z - 0.075
		iniciar()
	self.tiempo += 1

func _on_KinematicBody_startExpl():
	iniciar()
