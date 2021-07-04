extends Spatial

var presented = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if presented==0:
	#	DataManager.call_HUD("res://Scenes/GUI/IntroTextCtrl.tscn")
	#	$ExpOST.play()
	#	$KinematicBody2.changespeed(0)

func msgReceive(msg):
	if msg == "ready":
		DataManager.call_HUD("res://Scenes/GUI/IntroTextCtrl.tscn")
		$ExpOST.play()
		$KinematicBody2.changespeed(0)
	if msg == "move":
		$KinematicBody2.changespeed(1) ## cambia la velocidad del jugador
	if msg == "change":
		DataManager.change_to_specific_map("1")
		#DataManager.removeScenes()

#func _on_Monitor_activateMenu():
#	DataManager.call_HUD("res://Scenes/GUI/NumericPanel.tscn")


func _on_Terminal_activate():
	$Screen._activate()

func _on_Screen_machineError():
	$Particulas/Particles.show()
	$Particulas/Particles2.show()
	$Particulas.iniciar()
