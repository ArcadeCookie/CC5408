extends Control

var animReady
var playing
var textnum
var newtext

func _ready():
	$Texto/Anim.play("items")
	playing = true
	animReady = false
	textnum = 0

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			$Texto/Anim.advance(5)
		elif playing==false and animReady==true:
			$Texto/Anim.stop(true)
			$Texto.hide()
			if textnum == 5: # indicacion maquina
				DataManager.player_play()
				DataManager.changeObjective("I have to go to Dr. Light's laboratory to prepare a tube of V-3234.", false)
				DataManager.remove_unique_HUD(self)
			else:
				$Texto.text = newtext
				$Texto.show()
				playing = true
				$Texto/Anim.play("items")

func _on_Anim_animation_finished(anim_name):
	playing = false	
	textnum += 1
	if textnum == 1:
		newtext = "Let's see."
	elif textnum == 2:
		newtext = "..."
	elif textnum == 3:
		newtext = "Okay, I now know what I need to produce a tube of V-3234. "
	elif textnum == 4:
		newtext = "I have to go to Dr. Light's laboratory and see \n if he has there the substances I need to mix it."
	animReady=true
