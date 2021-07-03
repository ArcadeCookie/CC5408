extends Control

onready var Codigo
onready var Displayer := $Displayer/Label
onready var Indicator := $Indicator/AnimationPlayer
var correcto = "1997"
signal success

# Called when the node enters the scene tree for the first time.
func _ready():
	Codigo = ""
	pass # Replace with function body.

func mostrarLabel():
	Displayer.text	= Codigo
	if len(Codigo) == 4:
		if Codigo==correcto:
			Indicator.play("success")
			yield(Indicator, "animation_finished")
			emit_signal("success")
		else:
			Indicator.play("fail")
			yield(Indicator, "animation_finished")
			Codigo = ""
			Displayer.text	= Codigo
			DataManager.remove_HUD(self)
	


func _on_Numero1_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(1)
		mostrarLabel()

func _on_Numero2_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(2)
		mostrarLabel()

func _on_Numero3_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(3)
		mostrarLabel()

func _on_Numero4_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(4)
		mostrarLabel()

func _on_Numero5_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(5)
		mostrarLabel()

func _on_Numero6_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(6)
		mostrarLabel()

func _on_Numero7_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(7)
		mostrarLabel()

func _on_Numero8_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(8)
		mostrarLabel()

func _on_Numero9_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(9)
		mostrarLabel()

func _on_Numero0_pressed():
	if len(Codigo) != 4:
		Codigo = Codigo + str(0)
		mostrarLabel()
