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
			if textnum > 4: # indicacion maquina
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
		newtext = "\n \n This is the lab, but something seems off."
	elif textnum == 2:
		newtext = "\n \n ..."
	elif textnum == 3:
		newtext = "\n \n There's nobody around."
	elif textnum == 4:
		newtext = "\n \n I should check the machine."
	animReady=true
