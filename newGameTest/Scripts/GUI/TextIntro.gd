extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
#onready var TextocFormato = $TextocFormato
#onready var TextocFormatoAnim = $TextocFormato/Anim
var playing
var animReady
var textnum
var newtext
var SpaceBar

func _ready():
	TextoAnim.play("showText")
	DataManager.player_stop()
	playing = true
	animReady = false
	textnum = 0
	SpaceBar = 0

func _unhandled_key_input(event : InputEventKey) -> void:
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			TextoAnim.advance(5)
		elif playing==false and animReady==true:
			TextoAnim.stop(true)
			Texto.hide()
			if textnum == 4: # indicacion maquina
				$TextocFormato.show()
				$TextocFormato.bbcode_text = newtext
				$TextocFormato/AnimF.play("wait")
				DataManager.player_play()
				$SpaceBar.showing = 0
				$SpaceBar.hide()
				textnum += 1
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
		if SpaceBar == 0:
			$SpaceBar._play()
			SpaceBar = 1
		newtext = "After all that effort and now just being a\n supporter, I thought you were going to have\n a grudge towards Dr. Light or the project."
	elif textnum == 2:
		newtext = "\n But here we are, about to witness a huge step\n for mankind and it's all thanks to you."
	elif textnum == 3:
		newtext = "\n Imagine being the one starting up the machine, \n I envy you. You better hurry up, it's starting soon!"
	elif textnum == 4:
		newtext = "\n Go and activate the [color=#209f88]machine[/color]."
	animReady=true


func _on_AnimF_animation_finished(anim_name):
	if anim_name == "wait":
		DataManager.changeObjective("I have to activate the machine.", false)
		DataManager.remove_HUD(self)
