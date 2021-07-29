extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
var playing
var animReady
var textnum
var newtext

func _ready():
	TextoAnim.play("items")
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
				DataManager.player_play()
				DataManager.remove_unique_HUD(self)
			else:
				Texto.text = newtext
				Texto.show()
				playing = true
				TextoAnim.play("items")
			animReady=false

func _on_Anim_animation_finished(anim_name):
	playing = false	
	textnum += 1
	if textnum == 1:
		newtext = "Okay, the machine is still turned on. \n Let's check the status of the pieces."
	elif textnum == 2:
		newtext = "..."
	elif textnum == 3:
		newtext = "There are missing pieces?"
	elif textnum == 4:
		newtext = "..."
	elif textnum == 5:
		newtext = "Damn, I can't start the machine like this. \n I have to get the missing pieces first."
	elif textnum == 6:
		newtext = "For now, I have to refuel the machine. so I have to create more V-3234. \n The main office had information about it, I have to go there."
	elif textnum == 7:
		newtext = "I had to check the notes in my office to remember the password."
	animReady=true
