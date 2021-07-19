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
		print("called")
		#DataManager.call_HUD("res://Scenes/GUI/IntroTextCtrl.tscn")
		#$ExpOST.play()
		$KinematicBody2.changespeed(0)
	if msg == "move":
		print("called move")
		$KinematicBody2.changespeed(1) ## cambia la velocidad del jugador
	#if msg == "change":
	#	DataManager.change_to_specific_map("1")
		#DataManager.removeScenes()
	#if msg == "beginexp":
		#$Particulas/Particles3.show()
	#if msg == "error1":
	#	$Particulas/Particles.show()
	#	$WarningLight.show()
	#	$WarningLight2.show()
	#	$WarningLight3.show()
	#	$WarningLight4.show()
	#	$LightAnim.play("intermittence_in")
		## aqui luces rojas
	#if msg == "error2":
	#	$Particulas/Particles2.show()
	#	$ExpOST.stop()
	#	$WarningSound.play()
		## aqui sonido warning
	#if msg == "error3":
	#	$KinematicBody2/Camera/ScreenShaker.start()
	#	$Particulas.iniciar()
	else:
		pass

#func _wakeup():
#	$KinematicBody2/Camera/ScreenShaker._wakeup()

#func _on_Monitor_activateMenu():
#	DataManager.call_HUD("res://Scenes/GUI/NumericPanel.tscn")


#func _on_Terminal_activate():
#	$Screen._activate()

#func _on_Screen_machineError():
#	$Particulas/Particles.show()
#	$Particulas/Particles2.show()
#	$Particulas.iniciar()


#func _on_LightAnim_animation_finished(anim_name):
#	if anim_name == "intermittence_in":
#		$LightAnim.play("intermittence_out")
#	if anim_name == "intermittence_out":
#		$LightAnim.play("intermittence_in")

