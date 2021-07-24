extends Control

onready var Codigo
onready var Displayer := $DisplayText
onready var Indicator := $PasswordThingy/AnimationPlayer
var correcto = "091322"

# Called when the node enters the scene tree for the first time.
func _ready():
	Codigo = ""
	pass # Replace with function body.

func mostrarLabel(numero):
	if len(Codigo) < 6:
		Codigo = Codigo + str(numero)
		Displayer.text	= Codigo
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
	DataManager.remove_HUD(self)

func _on_Enter_pressed():
	if len(Codigo) == 6:
		if Codigo==correcto:
			# sonido exito aca
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			DataManager.remove_HUD(self)
		else:
			# sonido de fallo aca
			Codigo = ""
			Displayer.text = Codigo
	else:
		## sonido de fallo aca
		Codigo = ""
		Displayer.text = Codigo

func _on_Del_pressed():
	if len(Codigo) > 0:
		var temp_text = ""
		for i in range(len(Codigo)-1):
			temp_text += Codigo[i]
		Codigo = temp_text	
		Displayer.text = Codigo	
