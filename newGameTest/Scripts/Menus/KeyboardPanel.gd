extends Control

onready var Codigo
onready var Displayer := $Displayer/Label
onready var Indicator := $Indicator/AnimationPlayer
var correcto = "TEST"
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
			Codigo = ""
			Displayer.text	= Codigo
		else:
			Indicator.play("fail")
			yield(Indicator, "animation_finished")
			Codigo = ""
			Displayer.text	= Codigo


func _on_Q_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "Q"
		mostrarLabel()

func _on_W_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "W"
		mostrarLabel()


func _on_E_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "E"
		mostrarLabel()


func _on_R_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "R"
		mostrarLabel()


func _on_T_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "T"
		mostrarLabel()


func _on_Y_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "Y"
		mostrarLabel()


func _on_U_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "U"
		mostrarLabel()


func _on_I_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "I"
		mostrarLabel()


func _on_O_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "O"
		mostrarLabel()


func _on_P_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "P"
		mostrarLabel()


func _on_A_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "A"
		mostrarLabel()


func _on_S_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "S"
		mostrarLabel()


func _on_D_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "D"
		mostrarLabel()


func _on_F_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "F"
		mostrarLabel()


func _on_G_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "G"
		mostrarLabel()


func _on_H_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "H"
		mostrarLabel()


func _on_J_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "J"
		mostrarLabel()


func _on_K_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "K"
		mostrarLabel()


func _on_L_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "L"
		mostrarLabel()


func _on_Z_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "Z"
		mostrarLabel()


func _on_X_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "X"
		mostrarLabel()


func _on_C_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "C"
		mostrarLabel()


func _on_V_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "V"
		mostrarLabel()


func _on_B_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "B"
		mostrarLabel()


func _on_N_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "N"
		mostrarLabel()


func _on_M_pressed():
	if len(Codigo) < 4:
		Codigo = Codigo + "M"
		mostrarLabel()
