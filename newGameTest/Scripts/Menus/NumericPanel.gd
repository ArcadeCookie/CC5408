extends Control

onready var Codigo
onready var Displayer := $Displayer/Label
onready var Indicator := $Indicator/AnimationPlayer
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
				Indicator.play("success")
				yield(Indicator, "animation_finished")
			else:
				Indicator.play("fail")
				yield(Indicator, "animation_finished")
				Codigo = ""
				Displayer.text	= Codigo
				DataManager.remove_HUD(self)
	else:
		return

func _on_Exit_pressed():
	DataManager.remove_HUD(self)

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
