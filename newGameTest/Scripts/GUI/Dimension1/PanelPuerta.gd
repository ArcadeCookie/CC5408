extends Control

onready var Codigo
onready var Displayer := $DisplayText
onready var Indicator := $PasswordThingy/AnimationPlayer
var correcto = "2836"

# Called when the node enters the scene tree for the first time.
func _ready():
	Codigo = ""
	pass # Replace with function body.

func mostrarLabel(numero):
	if len(Codigo) < 4:
		Codigo = Codigo + str(numero)
		Displayer.text	= Codigo
		if len(Codigo) == 4:
			if Codigo==correcto:
				Indicator.play("accepted")
				AudioManager.play_FX("res://Resources/Sounds/CorrectPassword.wav")
				yield(Indicator, "animation_finished")
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				DataManager.player_play()
				var world = get_parent()
				world = world.get_parent()
				world.get_node("Navigation/NavigationMeshInstance/World/Spatial/PanelPuertaOficina")._openDoor()
				DataManager.remove_unique_HUD(self)
			else:
				Indicator.play("rejected")
				AudioManager.play_FX("res://Resources/Sounds/IncorrectPassword.wav")
				yield(Indicator, "animation_finished")
				Codigo = ""
				Displayer.text = Codigo
	else:
		return

func _on_Numero1_pressed():
	mostrarLabel(1)

func _on_Numero2_pressed():
	mostrarLabel(2)

func _on_Numero3_pressed():
	mostrarLabel(3)

func _on_Numero4_pressed():
	mostrarLabel(4)

func _on_Numero5_pressed():
	mostrarLabel(5)

func _on_Numero6_pressed():
	mostrarLabel(6)

func _on_Numero7_pressed():
	mostrarLabel(7)

func _on_Numero8_pressed():
	mostrarLabel(8)

func _on_Numero9_pressed():
	mostrarLabel(9)

func _on_Numero0_pressed():
	mostrarLabel(0)

func _on_Close_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	#var world = get_parent()
	#world = world.get_parent()
	#world.get_node("Navigation/NavigationMeshInstance/World/Spatial/PanelPuertaOficina")._openDoor()
	DataManager.player_play()
	DataManager.remove_unique_HUD(self)
