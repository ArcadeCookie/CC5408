extends Control

onready var Codigo
onready var Displayer := $Displayer/Label
onready var Indicator := $Indicator/AnimationPlayer
var correcto = "IAMGOAT"

# Called when the node enters the scene tree for the first time.
func _ready():
	Codigo = ""
	pass # Replace with function body.

func mostrarLabel(character):
	if len(Codigo) < 7:
		Codigo = Codigo + str(character)
		Displayer.text	= Codigo
		if len(Codigo) == 7:
			if Codigo==correcto:
				Indicator.play("success")
				yield(Indicator, "animation_finished")
				emit_signal("success")
				Codigo = ""
				Displayer.text	= Codigo
			else:
				Indicator.play("fail")
				yield(Indicator, "animation_finished")
				Codigo = ""
				Displayer.text	= Codigo
	else:
		return


func _on_Q_pressed():
	mostrarLabel("Q")

func _on_W_pressed():
	mostrarLabel("W")

func _on_E_pressed():
	mostrarLabel("E")

func _on_R_pressed():
	mostrarLabel("R")

func _on_T_pressed():
	mostrarLabel("T")

func _on_Y_pressed():
	mostrarLabel("Y")

func _on_U_pressed():
	mostrarLabel("U")

func _on_I_pressed():
	mostrarLabel("I")

func _on_O_pressed():
	mostrarLabel("O")

func _on_P_pressed():
	mostrarLabel("P")

func _on_A_pressed():
	mostrarLabel("A")

func _on_S_pressed():
	mostrarLabel("S")

func _on_D_pressed():
	mostrarLabel("D")

func _on_F_pressed():
	mostrarLabel("F")

func _on_G_pressed():
	mostrarLabel("G")

func _on_H_pressed():
	mostrarLabel("H")

func _on_J_pressed():
	mostrarLabel("J")

func _on_K_pressed():
	mostrarLabel("K")

func _on_L_pressed():
	mostrarLabel("L")

func _on_Z_pressed():
	mostrarLabel("Z")

func _on_X_pressed():
	mostrarLabel("X")

func _on_C_pressed():
	mostrarLabel("C")

func _on_V_pressed():
	mostrarLabel("V")

func _on_B_pressed():
	mostrarLabel("B")

func _on_N_pressed():
	mostrarLabel("N")

func _on_M_pressed():
	mostrarLabel("M")
