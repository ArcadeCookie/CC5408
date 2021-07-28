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
			if textnum == 5:
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
		newtext = "Wait, the pieces of the mixer seem a bit loose..."
	elif textnum == 3:
		newtext = "Damn, I can't do the mixing like this. \n It needs perfect precision to properly mix everything..."
	elif textnum == 4:
		newtext = "I need a screwdriver to fix them. There should be one in the warehouse."
	animReady=true
