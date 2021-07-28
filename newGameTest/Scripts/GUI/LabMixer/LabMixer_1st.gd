extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
var playing
var animReady
var textnum
var newtext
var SpaceBar

func _ready():
	TextoAnim.play("items")
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
			if textnum == 5: # indicacion maquina
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
		if SpaceBar == 0:
			$SpaceBar._play()
			SpaceBar = 1
		newtext = "..."
	elif textnum == 2:
		newtext = "..."
	elif textnum == 3:
		newtext = "Okay, I only need to find a proper amount of Polyphenol, \n a bottle of Item 2, and Item 3."
	elif textnum == 4:
		newtext = "There should be a bottle of Item 2 in this lab. I can get Polyphenol from Oil, \n so the Kitchen should have that. And Item 3 should be in that place."
	animReady=true


func _on_AnimF_animation_finished(anim_name):
	playing = false	
	textnum += 1
