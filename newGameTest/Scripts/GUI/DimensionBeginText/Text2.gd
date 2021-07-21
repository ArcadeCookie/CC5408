extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
var playing
var animReady
var textnum
var newtext

func _ready():
	TextoAnim.play("showText")
	playing = true
	animReady = false
	textnum = 0

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			TextoAnim.advance(5)
		elif playing==false and animReady==true:
			TextoAnim.stop(true)
			Texto.hide()
			if textnum >= 8: # indicacion maquina
				pass
			else:
				Texto.text = newtext
				Texto.show()
				playing = true
				TextoAnim.play("showText")
			animReady=false

func _on_Anim_animation_finished(anim_name):
	playing = false	
	textnum += 1
	if textnum == 1:
		newtext = "\n Okay, the machine still seems turned on. \n I have to check the log of the experiment."
	elif textnum == 2:
		newtext = "\n \n ..."
	elif textnum == 3:
		newtext = "\n \n There are missing pieces?"
	elif textnum == 4:
		newtext = "\n \n ..."
	elif textnum == 5:
		newtext = "\n Damn, I can't start the machine like this. \n I have to get the missing pieces first."
	elif textnum == 6:
		newtext = "..."
	elif textnum == 7:
		newtext = "\n \n I need the password to get details of the missing pieces. \n It should be in one of the offices' computers."
	animReady=true
