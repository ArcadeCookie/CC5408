extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
var playing
var animReady
var textnum
var newtext

func _ready():
	DataManager.player_stop()
	DataManager.camera_stop()
	$ColorRect/Anim.play("fade")

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			TextoAnim.advance(5)
		elif playing==false and animReady==true:
			TextoAnim.stop(true)
			Texto.hide()
			if textnum == 5: # indicacion maquina
				#DataManager.player_play()
				#DataManager.camera_play()
				#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
				DataManager.remove_unique_HUD(self)
			else:
				Texto.text = newtext
				Texto.show()
				playing = true
				TextoAnim.play("items")
			animReady=false

func _on_Anim_animation_finished(anim_name):
	if anim_name == "fade":
		TextoAnim.play("items")
		playing = true
		animReady = false
		textnum = 0
	else:
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
		#if textnum == 5:
		#	DataManager.player_play()
		#	DataManager.remove_unique_HUD(self)
		animReady=true
