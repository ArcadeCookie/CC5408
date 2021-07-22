extends Control

onready var Texto = $Texto
onready var TextoAnim = $Texto/Anim
var playing
var animReady
var textnum
var newtext

# Called when the node enters the scene tree for the first time.
func _ready():
	TextoAnim.play("init")
	playing = true
	animReady = false
	textnum = 0

func _unhandled_key_input(event : InputEventKey) -> void:
	if textnum == -1:
		return
	if Input.is_action_just_pressed("ui_select"):
		if playing==true:
			TextoAnim.advance(5)
		elif playing==false and animReady==true:
			TextoAnim.stop(true)
			Texto.hide()
			if textnum == 6: # indicacion maquina
				$Exit.show()
				textnum = -1
			else:
				Texto.text = newtext
				Texto.show()
				playing = true
				TextoAnim.play("show")
				animReady=false
	
func _on_Exit_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	DataManager.remove_HUD(self)


func _on_Anim_animation_finished(anim_name):
	if anim_name == "init":
		TextoAnim.play("show")
	else:
		playing = false	
		textnum += 1
		if textnum == 1:
			newtext = "This place is enormous. I don't remember it so well, \n since I spent most of the time in the main lab and my office."
		elif textnum == 2:
			newtext = "If I remember correctly, there were some blueprints \n of the complex in the Archive Room right beside."
		elif textnum == 3:
			newtext = "Gotta remember the password to \n not waste time in there though."
		elif textnum == 4:
			newtext = "\n V-3234..."
		elif textnum == 5:
			newtext = "\n If this works again..."
		animReady=true
