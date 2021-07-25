extends "res://Scripts/Objects/TerminalBody.gd"
# Specific instance of a Terminal object
# Hierarchy: This -> TerminalBody -> Node -> ...

# Exectuted on generation of the instance, giving the object this value for id
func _init():
	id = 0 
	# After this, the object gets instanciated with TerminalBody._ready()

# Overriden method so this specific instance of a whole terminal node can have
# specific desired behaviour
func on_activation():
	#DataManager.call_HUD("res://Scenes/GUI/NumericPanel.tscn")
	DataManager.call_HUD("res://Scenes/GUI/IntroMonitor.tscn")
	$Screen._activate()

func _on_LightAnim_animation_finished(anim_name):
	if anim_name == "intermittence_in":
		$LightAnim.play("intermittence_out")
	if anim_name == "intermittence_out":
		$LightAnim.play("intermittence_in")

func beginexp():
	$Particulas/Particles3.show()

func error1():
	$Particulas/Particles.show()
	$WarningLight.show()
	$WarningLight2.show()
	$WarningLight3.show()
	$WarningLight4.show()
	$LightAnim.play("intermittence_in")

func error2():
	$Particulas/Particles2.show()
	$WarningSound.play()
	## aqui sonido warning

func error3():
	var world = get_parent()
	world.get_node("Player/Camera/ScreenShaker").start()
	$Particulas.iniciar()
